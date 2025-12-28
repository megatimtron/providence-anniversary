const https = require('https');
const http = require('http');

exports.handler = async (event) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json'
  };

  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  const { url } = JSON.parse(event.body || '{}');

  if (!url) {
    return {
      statusCode: 400,
      headers,
      body: JSON.stringify({ error: 'URL is required' })
    };
  }

  try {
    const html = await fetchUrl(url);
    const metadata = extractMetadata(html, url);

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify(metadata)
    };
  } catch (error) {
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: error.message })
    };
  }
};

function fetchUrl(url, redirectCount = 0) {
  if (redirectCount > 5) {
    return Promise.reject(new Error('Too many redirects'));
  }

  return new Promise((resolve, reject) => {
    const protocol = url.startsWith('https') ? https : http;

    const req = protocol.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; LinkPreview/1.0)'
      },
      timeout: 10000
    }, (res) => {
      // Handle redirects
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        let redirectUrl = res.headers.location;
        if (redirectUrl.startsWith('/')) {
          const urlObj = new URL(url);
          redirectUrl = `${urlObj.protocol}//${urlObj.host}${redirectUrl}`;
        }
        return resolve(fetchUrl(redirectUrl, redirectCount + 1));
      }

      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    });

    req.on('error', reject);
    req.on('timeout', () => {
      req.destroy();
      reject(new Error('Request timeout'));
    });
  });
}

function extractMetadata(html, url) {
  const getMetaContent = (property) => {
    const patterns = [
      new RegExp(`<meta[^>]*property=["']${property}["'][^>]*content=["']([^"']+)["']`, 'i'),
      new RegExp(`<meta[^>]*content=["']([^"']+)["'][^>]*property=["']${property}["']`, 'i'),
      new RegExp(`<meta[^>]*name=["']${property}["'][^>]*content=["']([^"']+)["']`, 'i'),
      new RegExp(`<meta[^>]*content=["']([^"']+)["'][^>]*name=["']${property}["']`, 'i')
    ];

    for (const pattern of patterns) {
      const match = html.match(pattern);
      if (match) return match[1];
    }
    return null;
  };

  const titleMatch = html.match(/<title[^>]*>([^<]+)<\/title>/i);

  // Get price from various sources
  let price = getMetaContent('product:price:amount') ||
              getMetaContent('og:price:amount') ||
              getMetaContent('price');

  // Try to find price in common patterns if not in meta
  if (!price) {
    const pricePatterns = [
      /\$[\d,]+\.?\d*/,
      /USD\s*[\d,]+\.?\d*/i
    ];
    for (const pattern of pricePatterns) {
      const match = html.match(pattern);
      if (match) {
        price = match[0];
        break;
      }
    }
  }

  let image = getMetaContent('og:image') || getMetaContent('twitter:image');

  // Make relative URLs absolute
  if (image && !image.startsWith('http')) {
    const urlObj = new URL(url);
    image = image.startsWith('/')
      ? `${urlObj.protocol}//${urlObj.host}${image}`
      : `${urlObj.protocol}//${urlObj.host}/${image}`;
  }

  return {
    title: getMetaContent('og:title') || getMetaContent('twitter:title') || (titleMatch ? titleMatch[1].trim() : null),
    description: getMetaContent('og:description') || getMetaContent('twitter:description') || getMetaContent('description'),
    image: image,
    siteName: getMetaContent('og:site_name') || new URL(url).hostname.replace('www.', ''),
    price: price,
    url: url
  };
}
