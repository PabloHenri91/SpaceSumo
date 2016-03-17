var app = require('http').createServer();

app.listen(8900);

function Game() {
    console.log('Game()');
    this.io = require('socket.io')(app);
    this.addHandlers();
}

Game.prototype.addHandlers = function() {
    console.log('addHandlers()');

    var allRooms = this.io.sockets.adapter.rooms;

    this.io.sockets.on('connection', function(socket) {
        console.log('connection ' + socket.id);
        
        socket.name = socket.id;
        socket.join(socket.id);
        
        socket.emit('userDisplayInfo');
        console.log(socket.name + ' emit : userDisplayInfo');
        
        socket.emit('userInfo');
        console.log(socket.name + ' emit userInfo: ');
        
        socket.on('userDisplayInfo', function (userDisplayInfo) {
            console.log(socket.name + ' on userDisplayInfo: ' + userDisplayInfo);
            
            socket.name = userDisplayInfo;
            socket.userDisplayInfo = userDisplayInfo;
        });
        
        socket.on('userInfo', function (userInfo) {
            console.log(socket.name + ' on userInfo: ' + userInfo);
            
            socket.userInfo = userInfo;
        });
        
        socket.on('update', function(data) {
            console.log(socket.name + ' on update: ' + data);
            
            for (var room in socket.adapter.sids[socket.id]) {
                socket.broadcast.to(room).emit('update', data);
                console.log(socket.name + ' emit update: ' + data);
            }
        });
        
        socket.on('leaveRooms', function() {
            console.log(socket.name + ' on leaveRooms: ');
            
            for (var room in socket.adapter.sids[socket.id]) {
                socket.leave(room);
            }
        });

        socket.on('getAllRooms', function() {
            console.log(socket.name + ' on getAllRooms: ');
            
            socket.emit('getAllRooms', allRooms);
            console.log(socket.name + ' emit getAllRooms: ' + allRooms);
        });

        socket.on('joinRoom', function(room) {
            console.log(socket.name + ' on joinRoom: ' + room);
            
            socket.join(room);
        });
        
        socket.on('disconnect', function() {
            console.log(socket.name + ' on disconnect: ');
            
        });
    });
};

// Start the game server
var game = new Game();
