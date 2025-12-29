// Netlify serverless function to proxy Gemini API calls
// API key is stored in Netlify environment variables - never exposed to client

exports.handler = async (event) => {
    const GEMINI_API_KEY = process.env.GEMINI_API_KEY;

    if (!GEMINI_API_KEY) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'API key not configured' })
        };
    }

    // Only allow POST requests
    if (event.httpMethod !== 'POST') {
        return {
            statusCode: 405,
            body: JSON.stringify({ error: 'Method not allowed' })
        };
    }

    try {
        const { action, model, contents } = JSON.parse(event.body);

        let url;
        let fetchOptions = {
            method: 'GET',
            headers: { 'Content-Type': 'application/json' }
        };

        if (action === 'listModels') {
            url = `https://generativelanguage.googleapis.com/v1beta/models?key=${GEMINI_API_KEY}`;
        } else if (action === 'generateContent') {
            url = `https://generativelanguage.googleapis.com/v1beta/${model}:generateContent?key=${GEMINI_API_KEY}`;
            fetchOptions.method = 'POST';
            fetchOptions.body = JSON.stringify({ contents });
        } else {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'Invalid action' })
            };
        }

        const response = await fetch(url, fetchOptions);
        const data = await response.json();

        return {
            statusCode: response.ok ? 200 : response.status,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify(data)
        };
    } catch (error) {
        console.error('Gemini proxy error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to process request' })
        };
    }
};
