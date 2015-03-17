{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<$>))
import Data.Monoid
import qualified Data.Set as Set
import Text.Pandoc.Options
import Hakyll

main :: IO ()
main = hakyll $ do

    --rules to copy files (nearly) unmodified

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/**" $ do
        route   idRoute
        compile compressCssCompiler

    match "favicon.ico" $ do
        route idRoute
        compile copyFileCompiler

    match "resources/**" $ do
        route idRoute
        compile copyFileCompiler

    match "overview.md" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler'
            >>= loadAndApplyTemplate "_templates/default.html" defaultContext
            >>= relativizeUrls

    --building docs and doc-related pages
    --for some reason, moving it this late gets the links right while putting it first doesn't
    tags <- buildTags "docs/*" $ fromCapture "tags/*.html"

    match "docs/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler'
            >>= loadAndApplyTemplate "_templates/doc.html" (taggedDocCtx tags)
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "_templates/default.html" defaultContext
            >>= relativizeUrls

    create ["documentation.html"] $ do
        route idRoute
        compile $ do
            let archiveCtx =
                    field "docs" (const $ docList recentFirst)    `mappend`
                    constField "title" "Docs"                     `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "_templates/docs.html" archiveCtx
                >>= loadAndApplyTemplate "_templates/default.html" archiveCtx
                >>= relativizeUrls

    --building tag pages and tag cloud
    tagsRules tags $ \tag pattern -> do
        let tagCtx = constField "title" ("Docs tagged " ++ tag) `mappend` defaultContext

        route idRoute
        compile $ do
            docsTagged tags pattern recentFirst
                >>= makeItem
                >>= loadAndApplyTemplate "_templates/tag.html" tagCtx
                >>= loadAndApplyTemplate "_templates/default.html" tagCtx
                >>= relativizeUrls

    create ["tags.html"] $ do
        route idRoute
        compile $ do
            let cloudCtx = constField "title" "Tags" `mappend` defaultContext

            renderTagCloud 100 300 tags
                >>= makeItem
                >>= loadAndApplyTemplate "_templates/cloud.html" cloudCtx
                >>= loadAndApplyTemplate "_templates/default.html" cloudCtx
                >>= relativizeUrls

    --building the front page
    match "index.html" $ do
        route idRoute
        compile $ do
            let indexCtx = field "doc" $ const (itemBody <$> mostRecentDoc)
            let homeCtx = constField "title" "Home" `mappend` defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "_templates/default.html" homeCtx
                >>= relativizeUrls


    --loading the templated
    match "_templates/*" $ compile templateCompiler


extensions :: Set.Set Extension
extensions = Set.fromList [Ext_inline_notes, Ext_tex_math_dollars]


mostRecentDoc :: Compiler (Item String)
mostRecentDoc = head <$> (recentFirst =<< loadAllSnapshots "docs/*" "content")


pandocCompiler' :: Compiler (Item String)
pandocCompiler' = pandocCompilerWith pandocMathReaderOptions pandocMathWriterOptions


pandocMathReaderOptions :: ReaderOptions
pandocMathReaderOptions = defaultHakyllReaderOptions {
        readerExtensions = Set.union (readerExtensions defaultHakyllReaderOptions) extensions
    }

pandocMathWriterOptions :: WriterOptions
pandocMathWriterOptions  = defaultHakyllWriterOptions {
        writerExtensions = Set.union (writerExtensions defaultHakyllWriterOptions) extensions,
        writerHTMLMathMethod = MathJax ""
}


docList :: ([Item String] -> Compiler [Item String]) -> Compiler String
docList sortFilter = do
    docs   <- sortFilter =<< loadAll "docs/*"
    itemTpl <- loadBody "_templates/doc-item.html"
    list    <- applyTemplateList itemTpl defaultContext docs
    return list


docsTagged :: Tags -> Pattern -> ([Item String] -> Compiler [Item String]) -> Compiler String
docsTagged tags pattern sortFilter = do
    template <- loadBody "_templates/doc-item.html"
    docs <- sortFilter =<< loadAll pattern
    applyTemplateList template defaultContext docs


taggedDocCtx :: Tags -> Context String
taggedDocCtx tags = tagsField "tags" tags `mappend` defaultContext


