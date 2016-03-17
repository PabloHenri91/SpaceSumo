var app = require('http').createServer();

app.listen(8900);

function Game() {
    console.log('Game()');
    this.io = require('socket.io')(app);
    this.addHandlers();
}

Game.prototype.addHandlers = function() {
    console.log('addHandlers()');

    var self = this;
    var allSockets = this.io.sockets
    var allRooms = this.io.sockets.adapter.rooms

    this.io.sockets.on('connection', function(socket) {
        console.log('connection ' + socket.id);
        
        socket.join(socket.id);
        
        socket.on('update', function(data) {
            console.log('update');
            console.log(data);

            for (i = 0; i < socket.rooms.length; i++) {
                socket.broadcast.to(socket.rooms[i]).emit('update', data);
            }
        });
        
        socket.on('leaveRooms', function() {
            console.log('leaveRooms');

            for (i = 0; i < socket.rooms.length; i++) {
                socket.leave(socket.rooms[i]);
            }
        });

        socket.on('getAllRooms', function() {
            console.log('getAllRooms');
            console.log(allRooms);
            
            socket.emit('getAllRooms', allRooms);

            for (i = 0; i < allRooms.length; i++) {
                allSockets[allRooms[i]].emit('hello')
            }
        });

        socket.on('joinRoom', function(room) {
            console.log('joinRoom');

            socket.join(room)
        });
        
        socket.on('disconnect', function() {
            console.log('disconnect' + socket.id);
        });
    });
};

// Start the game server
var game = new Game();
