<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

  <h1>🎓 ClassHub - Setup Guide</h1>

  <p>Welcome to <strong>ClassHub</strong> – your ultimate all-in-one study companion! Designed specifically for college students, ClassHub helps you manage and organize your academic journey with ease. Integrated with <strong>Gemini AI 🤖</strong>, it offers smart support to help you stay on top of:</p>
  
  <ul>
    <li>📚 Study Materials (Notes, PDFs, and Books)</li>
    <li>📄 Previous Year Papers (Solved & Unsolved)</li>
    <li>📝 Assignment Submissions</li>
    <li>📊 Personal Academic Records (Marksheets, SGPA, and Backlogs)</li>
    <li>🎯 Daily Study Goals and Progress Tracking (Coming Soon!)</li>
  </ul>

  <p><em>🚀 Built by students, for students — crafted with real college needs in mind.</em></p>

  <h2>🛠️ Tech Stack Overview</h2>
  <ul>
    <li>💻 <strong>Frontend:</strong> Flutter (Android & Web)</li>
    <li>🛠️ <strong>Backend:</strong> Node.js + Express</li>
    <li>🗄️ <strong>Database:</strong> MongoDB</li>
    <li>🤖 <strong>AI Integration:</strong> Google Gemini API</li>
  </ul>

  <h2>📂 Project Structure</h2>
  <pre>
/Backend-api     → 🌐 REST API built with Node.js + Express + MongoDB
/database        → 🗃️ MongoDB database backup files
/.env            → 🔑 Configuration file (API_URL, API_KEY)
  </pre>

<h2>🚀 Installation & Setup Guide</h2>

<h3>1️⃣ Clone the Repository</h3>
<p>🔽 Download the complete project code from GitHub:</p>
<pre>
git clone https://github.com/HELLFIRE-NILESH/class_hub.git
cd class_hub
</pre>

<h3>2️⃣ Install Flutter Dependencies</h3>
<p>📦 Get all required packages for the Flutter project:</p>
<pre>
flutter pub get
</pre>

<h3>3️⃣ Restore the MongoDB Database</h3>
<p>💾 Ensure MongoDB is installed and running. Restore the backup:</p>
<pre>
mongorestore --db class_hub ./database
</pre>

<h3>4️⃣ Setup the Backend API</h3>
<p>📡 Install backend dependencies and start the server:</p>
<pre>
cd backend-api
npm install
nodemon index
# or
npx nodemon index
</pre>
<p>🌐 The backend API will run on <code>http://0.0.0.0:8000</code>, making it accessible on your local network.</p>

<h3>5️⃣ Generate Your Gemini API Key</h3>
<p>🔑 For AI-powered features:</p>
<ul>
  <li>Go to: <a href="https://aistudio.google.com/app/apikey">https://aistudio.google.com/app/apikey</a></li>
  <li>Log in with your Google account.</li>
  <li>Create a new API key and copy it.</li>
</ul>

<h3>6️⃣ Find Your Local IPv4 Address</h3>
<p>🌐 Required to connect other devices in your network:</p>
<ul>
  <li>🪟 <strong>Windows:</strong>
    <pre>ipconfig</pre>
    Check <code>IPv4 Address</code> (Example: <code>192.168.1.5</code>)
  </li>
  <li>🐧 <strong>macOS/Linux:</strong>
    <pre>ifconfig</pre>
    Find <code>inet</code> under your active network (Example: <code>192.168.1.5</code>)
  </li>
</ul>

<h3>7️⃣ Add Configuration to <code>.env</code></h3>
<p>🔧 Open the <strong>.env</strong> file and set your keys:</p>
<pre>
API_KEY=your-gemini-api-key
URL=http://your-local-ipv4:8000
</pre>
<p>Replace <code>your-local-ipv4</code> with your actual IP (Example: <code>192.168.1.5</code>).</p>

<h3>8️⃣ Run the Flutter App on Android</h3>
<p>📱 Connect your Android phone (with USB debugging ON):</p>
<pre>
flutter run -d android
</pre>

<h4>✅ Pre-run Checklist:</h4>
<ul>
  <li>📶 Phone and PC on the same Wi-Fi network.</li>
  <li>🗃️ MongoDB is running with the restored database.</li>
  <li>🚀 Backend API is running smoothly without errors.</li>
  <li>📝 <strong>.env</strong> file is properly configured.</li>
</ul>

<hr>

<h2>🔑 Default Login Credentials</h2>
<p>Use these credentials for the first login:</p>
<pre>
ID (roll_no): 22113C04033
Password: grey_
</pre>

<h2>🆔 Roll Number Format</h2>
<p>For consistent data entry, <strong>roll numbers</strong> must follow this strict format:</p>
<pre>
#####A#####
</pre>
<p>Where:</p>
<ul>
  <li>🔢 <strong>#####</strong> – 5 digits (0-9)</li>
  <li>🔠 <strong>A</strong> – 1 uppercase alphabet (A-Z)</li>
  <li>🔢 <strong>#####</strong> – 5 digits (0-9)</li>
</ul>

<h4>✅ Valid Examples:</h4>
<ul>
  <li>22113C04033</li>
  <li>12345B67890</li>
</ul>

<h4>❌ Invalid Examples:</h4>
<ul>
  <li>1234C56789 (only 4 digits at start)</li>
  <li>ABCDE12345 (letters instead of numbers)</li>
  <li>12345CC6789 (two alphabets instead of one)</li>
</ul>


<h2>🔄 Adding or Updating Users</h2>
<p>To add a new user, send a POST request with user data in json body (using Postman or similar) to:</p>
<pre>
http://localhost:8000/api/auth/register
</pre>

<h3>Example JSON Body:</h3>
<pre>
{
  "roll_no": "12345C67890",
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
  "back_log": [201, 202],
  "password": "new_password"
}
</pre>


<h3>💡 Pro Tip:</h3>
<ul>
  <li>📝 Always keep a backup of your <code>.env</code> file.</li>
  <li>🔐 Never share your Gemini API key publicly.</li>
  <li>🆙 Regularly update user data through the API to keep records fresh.</li>
</ul>

<footer>
  <hr>
  <p>🚀 Made with ❤️ by <strong>Nilesh Prajapat</strong></p>
  <p><em>🎓 ClassHub – built by a student, for students, from real classroom experience.</em></p>
</footer>

</body>
</html>
