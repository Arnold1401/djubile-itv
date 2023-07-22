const express = require("express");

const app = express();
const router = require("./router");
const PORT = 3001;
const cors = require("cors");
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// app
app.use(router);
// WebSocket connections
const http = require("http");
const { Server } = require("socket.io");
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "http://localhost:5173",
    // origin: "http://127.0.0.1:59326/t2wJPHc9zKo=/",
    methods: ["GET", "POST"],
  },
});

io.on("connection", (socket) => {
  console.log(`User Connected:${socket.id}`);

  socket.on("join_room", (data) => {
    socket.join(data);
  });

  socket.on("leave_room", (roomID) => {
    socket.leave(roomID);
    console.log(`User left room: ${roomID}`);
  });

  socket.on("send_message", (data) => {
    console.log(data);
    // socket.broadcast.emit("receive_message", data.message);
    socket.to(data.room).emit("receive_message", data);
  });
});

// ---- CRON JOBS
// const sendNotification = require("./sendnotif");
// sendNotification.start();
//----

// Start the server
const port = 3001;
server.listen(port, () => {
  console.log(`Server started on port ${port}`);
});
