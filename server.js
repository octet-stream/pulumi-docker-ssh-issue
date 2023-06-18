import {createServer} from "node:net"

const server = createServer(socket => {
  console.log("A new connection established: %s", socket.remoteAddress)

  socket.on("data", buf => {
    const input = buf.toString("utf-8")
    console.log("Input: %s", input)

    socket.write(Buffer.from(`Output: ${input.toUpperCase()}`))
  })

  socket.on("close", () => console.log(
    "Connection closed: %s",

    socket.remoteAddress
  ))
})

server.listen(3030, () => console.log("Listen on port 3030"))
