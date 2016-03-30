var app = require('http').createServer();

app.listen(8900);

function Game() {
    console.log('Game()');
    this.io = require('socket.io')(app);
    this.addHandlers();
}

Game.prototype.addHandlers = function() {
    console.log('addHandlers()');
    
    var connectedSockets = this.io.sockets.connected;
    var allRooms = this.io.sockets.adapter.rooms;

    this.io.sockets.on('connection', function(socket) {
        console.log('connection ' + socket.id);
        
        socket.name = socket.id;
        
        socket.on('createRoom', function () {
            console.log(socket.name + ' on createRoom: ');
            
            socket.join(socket.id);
            
            socket.emit('currentRoomId', socket.id);
            console.log(socket.name + ' emit currentRoomId: ' + socket.id);
        });
        
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
            
            for (var roomId in allRooms) {
                
                var room = allRooms[roomId];
                var message = {};
                
                message.roomId = roomId;
                message.usersDisplayInfo = [];
                
                for (var socketsId in room.sockets) {
                    var someSocket = connectedSockets[socketsId];
                    
                    message.usersDisplayInfo.push(someSocket.userDisplayInfo);
                }
                
                socket.emit('getRoom', message);
                console.log(socket.name + ' emit getRoom: ');
                console.log(message);
            }
        });

        socket.on('joinRoom', function(roomId) {
            console.log(socket.name + ' on joinRoom: ' + roomId);
            
            for (var room in socket.adapter.sids[socket.id]) {
                socket.leave(room);
            }
            
            socket.join(roomId);
            
            var room = allRooms[roomId];
            var message = {};

            message.roomId = roomId;
            message.usersDisplayInfo = [];

            for (var socketsId in room.sockets) {
                var someSocket = connectedSockets[socketsId];
                
                someSocket.emit('joinRoom', socket.userDisplayInfo);
                console.log(socket.name + ' emit joinRoom: ');
                
                message.usersDisplayInfo.push(someSocket.userDisplayInfo);
            }

            socket.emit('joinRoom', message);
            console.log(socket.name + ' emit joinRoom: ' + message);
        });
        
        socket.on('disconnect', function() {
            console.log(socket.name + ' on disconnect: ');
            
            for (var roomId in socket.adapter.sids[socket.id]) {
                socket.leave(roomId);
            }
        });
    });
};

// Start the game server
var game = new Game();
