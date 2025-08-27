import asyncio
import aiohttp
from tqdm import tqdm
import time
import ssl

# CONFIGURE
CONCURRENT_REQUESTS = 200
TARGET_URL = 'https://localhost:8080//'  # <-- Replace with your actual endpoint
BEARER_TOKEN = 'eyJ.............................................................................'  # <-- Put your actual token here

# Disable SSL verification for localhost (safe only for testing)
ssl_context = ssl.create_default_context()
ssl_context.check_hostname = False
ssl_context.verify_mode = ssl.CERT_NONE

HEADERS = {
    "Authorization": f"Bearer {BEARER_TOKEN}"
}

async def send_request(session, i):
    try:
        async with session.get(TARGET_URL, headers=HEADERS, ssl=ssl_context) as response:
            return i, response.status
    except Exception as e:
        return i, f"Error: {str(e)}"

async def main():
    start_time = time.time()

    connector = aiohttp.TCPConnector(limit=0, ssl=ssl_context)
    async with aiohttp.ClientSession(connector=connector) as session:
        tasks = [send_request(session, i) for i in range(CONCURRENT_REQUESTS)]
        results = []
        for f in tqdm(asyncio.as_completed(tasks), total=CONCURRENT_REQUESTS, desc="Sending"):
            result = await f
            results.append(result)

    elapsed = time.time() - start_time
    print(f"\n⏱️ Completed {len(results)} requests in {elapsed:.2f} seconds")

    # Summary
    success = sum(1 for _, r in results if r == 200)
    failures = CONCURRENT_REQUESTS - success
    print(f"✅ Success: {success}")
    print(f"❌ Failures: {failures}")

# Run the script
if __name__ == '__main__':
    asyncio.run(main())
