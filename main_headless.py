import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from datetime import datetime
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import sys


# Set up your credentials and the URL
URL = 'https://magket.vercel.app/'
USERNAME = 'ksourmi@gmail.com'
PASSWORD = 'yourtherichboy'

chrome_options = Options()
chrome_options.add_argument("--headless")  # Enable headless mode
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.binary_location = "/usr/bin/chromium-browser"

# Initialize WebDriver with headless mode and Chromium
driver = webdriver.Chrome(options=chrome_options)

driver.get(URL)


# Log in to the website
time.sleep(2)  # Wait for the page to load
email_input = driver.find_element(By.XPATH, '//input[@type="email"]')
email_input.send_keys(USERNAME)  # Replace with your email

# Locate the password field
password_input = driver.find_element(By.XPATH, '//input[@type="password"]')
password_input.send_keys(PASSWORD)  # Replace with your password

login_button = driver.find_element(By.XPATH, '//button[@type="submit"]')  # Adjust as needed
login_button.click()

# Wait until 3:30 PM to start clicking
target_time = "16:29"
while True:
    current_time = datetime.now().strftime("%H:%M")
    if current_time >= target_time:
        break
    time.sleep(10)

# not allowing the page to show any alert
driver.execute_script("window.alert = function() {};")

while True:
    try:
        button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, '//button[@class="btn" and text()="Get Queue Number"]'))
        ) 
        button.click()
    except:
        now = datetime.now()
        if now.minute >= 35:
            break
        driver.refresh()
        time.sleep(2)

sys.exit()