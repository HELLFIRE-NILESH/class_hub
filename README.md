<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ClassHub Setup Guide</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
      line-height: 1.8;
      background-color: #f8f9fa;
      color: #212529;
    }
    h1, h2, h3 {
      color: #343a40;
    }
    pre {
      background-color: #212529;
      color: #f8f9fa;
      padding: 15px;
      border-radius: 8px;
      overflow-x: auto;
    }
    code {
      font-family: Consolas, monospace;
    }
  </style>
</head>
<body>

<h1>🎓 ClassHub</h1>
<p>
  <strong>ClassHub</strong> is a college study app with AI support, built to help students manage study materials, previous year papers, assignments, and personal academic records.
</p>

<h2>It has:</h2>
<ul>
  <li>🚀 Flutter frontend (for mobile or web)</li>
  <li>🛠️ Node.js + Express backend (API)</li>
  <li>🗃️ MongoDB database</li>
</ul>

<h2>📂 Project Structure</h2>
<ul>
  <li>/Backend-api → Node.js REST API (Express + MongoDB)</li>
  <li>/database → MongoDB database backup</li>
  <li>/.env → Configuration file (with your local IP)</li>
</ul>

<h2>🚀 Setup Instructions</h2>

<h3>1️⃣ Clone the Repository</h3>
<pre><code>git clone https://github.com/HELLFIRE-NILESH/class_hub.git
cd class_hub
</code></pre>

<h3>2️⃣ Restore the MongoDB Database</h3>
<p>Make sure MongoDB is installed and running.</p>
<pre><code>mongorestore --db class_hub ./database
</code></pre>

<h3>3️⃣ Setup the Backend API</h3>
<pre><code>cd backend-api
npm install
</code></pre>

<p>Start the API:</p>
<pre><code>npx nodemon index
</code></pre>

<p>Your backend API will be available at:</p>
<pre><code>http://localhost:8000
</code></pre>

<h3>4️⃣ Setup the Flutter App (Android)</h3>
<p>The Flutter app is in the root of the repository.</p>
<pre><code>flutter pub get
</code></pre>

<h3>5️⃣ Configure <code>.env</code> for IPv4</h3>
<p>In the root of the project, update the <code>.env</code> file like this:</p>
<pre><code>API_URL=http://&lt;your-local-ipv4&gt;:8000
</code></pre>

<p>🔍 Find your IPv4 address:</p>
<ul>
  <li>On Windows:</li>
  <pre><code>ipconfig
</code></pre>
  <li>On macOS/Linux:</li>
  <pre><code>ifconfig
</code></pre>
</ul>

<p>This is required so that your physical Android phone (connected to the same Wi-Fi network) can access your backend API.</p>

<h3>6️⃣ Run on Android</h3>
<pre><code>flutter run -d android
</code></pre>

<p>Make sure:</p>
<ul>
  <li>✅ Your phone and PC are on the same network.</li>
  <li>✅ Backend API is running on your machine.</li>
  <li>✅ IPv4 is correctly set in <code>.env</code> and used in Flutter code for API calls.</li>
</ul>

<h2>🔑 Default Login Credentials</h2>
<pre><code>ID (roll_no): 22113C04033
Password: grey_
</code></pre>

<h2>🔄 How to Add or Update Users</h2>
<p>Send a POST request to:</p>
<pre><code>http://&lt;your-ipv4&gt;:8000/api/auth/register
</code></pre>

<h3>Example Request Body (<code>application/json</code>):</h3>
<pre><code>{
  "roll_no": "22113C04034",
  "name": "John Doe",
  "dp": "https://raw.githubusercontent.com/HELLFIRE-NILESH/class_hub/main/assets/dp/johndoe.jpg",
  "mobile_no": "1234567890",
  "branch": "CSE",
  "sub": [101, 102, 103, 104, 105],
  "sem": 5,
  "sgpa": ["8.5", "8.7", "9.0"],
  "marksheet": [
    "https://drive.google.com/file/d/FILE_ID_1/view?usp=sharing",
    "https://drive.google.com/file/d/FILE_ID_2/view?usp=sharing",
    "https://drive.google.com/file/d/FILE_ID_3/view?usp=sharing"
  ],
  "back_log": [],
  "password": "new_password"
}
</code></pre>

</body>
</html>
