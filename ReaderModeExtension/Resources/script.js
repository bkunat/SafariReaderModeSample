function getPageContent() {
    const getReaderContent = () => {
        // Check for structured article data first
        const articleMeta = document.querySelector('script[type="application/ld+json"]');
        if (articleMeta) {
            try {
                const data = JSON.parse(articleMeta.textContent);
                if (data.articleBody) return data.articleBody;
            } catch (e) {}
        }

        // Look for elements that Safari Reader typically identifies
        const possibleContent = document.querySelector(
            'article, [role="article"], [itemprop="articleBody"], .post-content, ' +
            '[itemtype*="Article"] [itemprop="articleBody"], ' +
            '[data-testid="article-body"], .article__body'
        );

        if (possibleContent) {
            // Clone to avoid modifying the original DOM
            const content = possibleContent.cloneNode(true);
            
            // Remove elements that Reader mode typically excludes
            const unwantedSelectors = [
                '.social-share',
                '.advertisement',
                '.related-articles',
                '.newsletter-signup',
                '.comments',
                'script',
                'style',
                'button',
                '[role="complementary"]',
                '[data-advertisement]'
            ];
            
            unwantedSelectors.forEach(selector => {
                content.querySelectorAll(selector).forEach(el => el.remove());
            });

            // Get only paragraph text
            const paragraphs = Array.from(content.querySelectorAll('p, h1, h2, h3, h4, h5, h6'))
                .map(p => p.textContent.trim())
                .filter(text => text.length > 0);

            return paragraphs.join('\n\n');
        }

        return document.body.innerText;
    };

    const content = {
        title: document.title,
        body: getReaderContent().trim()
    };
    
    safari.extension.dispatchMessage("pageContent", { content });
}

// Listen for requests from the extension
safari.self.addEventListener("message", function(event) {
    if (event.name === "getContent") {
        getPageContent();
    }
});
