var app = require('http').createServer();

app.listen(8900);

function Game() {
    console.log("Game()");
    this.io = require('socket.io')(app);
    this.addHandlers();
}

Game.prototype.addHandlers = function() {
    console.log("addHandlers()");

    var self = this;
    var rooms = this.io.sockets.adapter.rooms

    this.io.sockets.on("connection", function(socket) {
        console.log("connection " + socket.id);
        
        socket.join(socket.id);
        
        socket.on("update", function(data) {
            console.log("update");
            
            socket.broadcast.emit("update", data);
        });
        
        socket.on("leaveRoom", function() {
            console.log("leaveRoom");
            
            socket.leave(socket.id);
        });

        socket.on("getRooms", function() {
            console.log("getRooms");
            console.log(rooms);
            
            socket.emit("getRooms", rooms);
        });
        
        //handler to remove the socket from memory when it disconnects
        socket.on('disconnect', function() {
            console.log("disconnect");
        });
    });
};

// Start the game server
var game = new Game();
