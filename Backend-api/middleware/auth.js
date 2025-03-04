import jwt from "jsonwebtoken";

export const authenticateToken = (req, res, next) => {
  const authHeader = req.header("Authorization");
  if (!authHeader) return res.status(401).json({ error: "Access Denied. No token provided." });

  const token = authHeader.split(" ")[1]; // Expected format: "Bearer <token>"
  if (!token) return res.status(401).json({ error: "Access Denied. Token missing." });

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET || "yourSecretKey"); // Fallback key for development
    req.user = verified; // Attach decoded user info to `req`
    next(); // Pass control to the next middleware/route
  } catch (err) {
    console.error("Token verification failed:", err);
    res.status(403).json({ error: "Invalid Token" });
  }
};
