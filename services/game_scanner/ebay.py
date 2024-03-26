import requests
from requests.auth import HTTPBasicAuth

# eBay API credentials
APP_ID = 'Your eBay App ID'
CERT_ID = 'Your eBay Cert ID'
DEV_ID = 'Your eBay Dev ID'
RU_NAME = 'Your eBay RuName'  # Redirect URL Name

# eBay API endpoints
BASE_URL = 'https://api.ebay.com'
API_VERSION = 'v1'

# Get eBay user access token using OAuth
def get_access_token():
    auth_url = f'{BASE_URL}/identity/v1/oauth2/token'
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    data = {
        'grant_type': 'client_credentials',
        'scope': 'https://api.ebay.com/oauth/api_scope',
    }
    auth = HTTPBasicAuth(f'{APP_ID}:{CERT_ID}')

    response = requests.post(auth_url, headers=headers, data=data, auth=auth)
    access_token = response.json().get('access_token')

    return access_token

# Get eBay user listings
def get_listings(access_token):
    listings_url = f'{BASE_URL}/sell/inventory/{API_VERSION}/inventory_item'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {access_token}',
    }

    response = requests.get(listings_url, headers=headers)
    listings = response.json()

    return listings

if __name__ == '__main__':
    access_token = get_access_token()
    
    if access_token:
        user_listings = get_listings(access_token)

        # Print or process the listings data
        print(user_listings)
    else:
        print('Failed to obtain access token.')
