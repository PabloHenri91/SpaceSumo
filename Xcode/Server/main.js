
var app = require('http').createServer();

app.listen(8900);

function Game() {
    console.log('Game()');
    this.io = require('socket.io')(app);
    this.addHandlers();
}

function Player(game, socket) {
    
    var player = this;
    
    this.socket = socket;
    this.game = game;
    
    this.socket.on('createRoom', function() {
        console.log(socket.name + ' on createRoom ');
        player.createRoom();
    });
    
    this.socket.on('userDisplayInfo', function(userDisplayInfo) {
        socket.name = userDisplayInfo;
        console.log(socket.name + ' on userDisplayInfo ');
        player.setUserDisplayInfo(userDisplayInfo);
    });

    this.socket.on('userInfo', function(userInfo) {
        console.log(socket.name + ' on userInfo ');
        player.setUserInfo(userInfo);
    });
    
    this.socket.on('update', function(data) {
        console.log(socket.name + ' on update ');
        player.update(data);
    });
    
    this.socket.on('leaveAllRooms', function() {
        console.log(socket.name + ' on leaveAllRooms ');
        player.leaveAllRooms();
    });
    
    this.socket.on('getAllRooms', function() {
        console.log(socket.name + ' on getAllRooms ');
        player.getAllRooms();
    });
    
    this.socket.on('getRoomInfo', function(roomId) {
        console.log(socket.name + ' on getRoomInfo ');
        player.getRoomInfo(roomId);
    });
    
    this.socket.on('joinRoom', function(roomId) {
        console.log(socket.name + ' on joinRoom ');
        player.joinRoom(roomId);
    });
    
    this.socket.on('disconnect', function() {
        console.log(socket.name + ' on disconnect ');
        player.disconnect();
    });
}

Player.prototype.leaveAllRooms = function() {
    for (var roomId in this.socket.adapter.sids[this.socket.id]) {
        this.leaveRoom(roomId);
    }
};

Player.prototype.leaveRoom = function(roomId) {
    this.socket.broadcast.to(roomId).emit('removePlayer', this.socket.id);
    console.log(this.socket.name + ' broadcast emit removePlayer ');
    this.socket.leave(roomId);
};

Player.prototype.createRoom = function() {
    this.socket.join(this.socket.id);
    this.socket.roomId = this.socket.id;
    this.socket.emit('currentRoomId', this.socket.id);
    console.log(this.socket.name + ' emit currentRoomId ');
};

Player.prototype.setUserDisplayInfo = function(userDisplayInfo) {
    this.socket.userDisplayInfo = userDisplayInfo;
};

Player.prototype.setUserInfo = function(userInfo) {
    this.socket.userInfo = userInfo;
};

Player.prototype.update = function(data) {
    for (var roomId in this.socket.adapter.sids[this.socket.id]) {
        this.socket.broadcast.to(roomId).emit('update', data);
        console.log(this.socket.name + ' broadcast emit update ');
    }
};

Player.prototype.getAllRooms = function() {
    for (var roomId in this.game.allRooms) {
        this.getRoomInfo(roomId);
    }
};

Player.prototype.getRoomInfo = function(roomId) {
    var room = this.game.allRooms[roomId];
    var roomInfo = {};
    roomInfo.roomId = roomId;
    roomInfo.usersDisplayInfo = [];
    for (var socketId in room.sockets) {
        var someSocket = this.game.connectedSockets[socketId];
        roomInfo.usersDisplayInfo.push(someSocket.userDisplayInfo);
    }
    this.socket.emit('roomInfo', roomInfo);
    console.log(this.socket.name + ' emit roomInfo ');
};

Player.prototype.joinRoom = function(roomId) {
    this.leaveAllRooms();
    this.socket.broadcast.to(roomId).emit('addPlayer', this.socket.userDisplayInfo);
    console.log(this.socket.name + ' broadcast emit addPlayer ');
    this.socket.join(roomId);
    this.socket.roomId = roomId;
    this.getRoomInfo(roomId);
};

Player.prototype.disconnect = function() {
    //TODO: avisar outros da sala
    this.leaveRoom(this.socket.roomId);
};

Game.prototype.addHandlers = function() {
    console.log('addHandlers()');
    
    var game = this;
    
    this.connectedSockets = this.io.sockets.connected;
    this.allRooms = this.io.sockets.adapter.rooms;
    
    this.io.sockets.on("connection", function(socket) {
        socket.name = socket.id;
        console.log(socket.name + ' on connection ');
        new Player(game, socket);
    });
};

// Start the game server
var game = new Game();
