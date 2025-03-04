<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ClassHub Setup Guide</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 40px;
      line-height: 1.8;
      background-color: #f5f5f5;
      color: #333;
      max-width: 900px;
      margin: auto;
    }
    h1, h2, h3, h4 {
      color: #222;
    }
    h1 {
      text-align: center;
      margin-bottom: 40px;
    }
    pre {
      background-color: #2d2d2d;
      color: #f8f8f2;
      padding: 15px;
      border-radius: 8px;
      overflow-x: auto;
    }
    code {
      font-family: Consolas, monospace;
    }
    ul {
      margin-left: 20px;
    }
    a {
      color: #007acc;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    .section {
      margin-bottom: 50px;
    }
  </style>
</head>
<body>

<h1>🎓 ClassHub - Setup Guide</h1>

<p>
  <strong>ClassHub</strong> is a powerful college study app with integrated AI support designed to help students manage:
</p>
<ul>
  <li>📚 Study materials</li>
  <li>📄 Previous year papers</li>
  <li>📝 Assignments</li>
  <li>📊 Personal academic records</li>
</ul>

<div class="section">
  <h2>🛠️ Tech Stack</h2>
  <ul>
    <li>🚀 <strong>Frontend:</strong> Flutter (Android & Web)</li>
    <li>🛠️ <strong>Backend:</strong> Node.js + Express</li>
    <li>🗃️ <strong>Database:</strong> MongoDB</li>
  </ul>
</div>

<div class="section">
  <h2>📂 Project Structure</h2>
  <ul>
    <li><code>/Backend-api</code> → Node.js REST API (Express + MongoDB)</li>
    <li><code>/database</code> → MongoDB database backup</li>
    <li><code>/.env</code> → Configuration file (your local IP)</li>
  </ul>
</div>

<div class="section">
  <h2>🚀 Installation & Setup</h2>

  <h3>1️⃣ Clone the Repository</h3>
  <pre><code>git clone https://github.com/HELLFIRE-NILESH/class_hub.git
cd class_hub
</code></pre>

  <h3>2️⃣ Restore the MongoDB Database</h3>
  <p>Ensure MongoDB is installed and running.</p>
  <pre><code>mongorestore --db class_hub ./database
</code></pre>

  <h3>3️⃣ Setup the Backend API</h3>
  <pre><code>cd backend-api
npm install
npx nodemon index
</code></pre>
  <p>API Running at: <a href="#">http://localhost:8000</a></p>

  <h3>4️⃣ Setup the Flutter App</h3>
  <p>The Flutter app is located in the root directory.</p>
  <pre><code>flutter pub get
</code></pre>

  <h3>5️⃣ Configure <code>.env</code> with Your IPv4 Address</h3>
  <p>Edit the <code>.env</code> file in the root directory:</p>
  <pre><code>API_URL=http://&lt;your-local-ipv4&gt;:8000
</code></pre>

  <h4>🔍 Find Your IPv4 Address:</h4>
  <ul>
    <li><strong>Windows:</strong></li>
    <pre><code>ipconfig
</code></pre>
    <li><strong>macOS/Linux:</strong></li>
    <pre><code>ifconfig
</code></pre>
  </ul>

  <h3>6️⃣ Run on Android</h3>
  <pre><code>flutter run -d android
</code></pre>

  <h4>✅ Checklist:</h4>
  <ul>
    <li>Phone & PC connected to the same Wi-Fi network.</li>
    <li>Backend API is running.</li>
    <li>Correct IPv4 is set in <code>.env</code>.</li>
  </ul>
</div>

<div class="section">
  <h2>🔑 Default Login Credentials</h2>
  <pre><code>ID (roll_no): 22113C04033
Password: grey_
</code></pre>
</div>

<div class="section">
  <h2>🔄 Adding or Updating Users</h2>
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
</div>

</body>
</html>
