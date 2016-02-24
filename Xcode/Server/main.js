/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



var app = require('http').createServer();

app.listen(8900);

function Player(socket) {
    console.log("Player(socket)");
    var self = this;

    this.socket = socket;
    this.name = "";
    this.game = {};

    //dados de update recebidos pelo player
    this.socket.on("update", function(x, y) {
        console.log("update");
        self.socket.broadcast.emit("update", self["name"], x, y);
    });
}

Player.prototype.joinGame = function(game) {
    console.log("joinGame(game)");
    this.game = game;
}

function Game() {
    console.log("Game()");

    this.io = require('socket.io')(app);

    this.players = new Array();

    this.addHandlers();
}

Game.prototype.addHandlers = function() {
    console.log("addHandlers()");

    var self = this;

    this.io.sockets.on("connection", function(socket) {
        self.addPlayer(new Player(socket));
    });
};

Game.prototype.addPlayer = function(player) {
    console.log("addPlayer(player)");

    player.game = this;
    this.players.push(player);

    player.socket.emit("Hello0", "Hello1");
};

// Start the game server
var game = new Game();

