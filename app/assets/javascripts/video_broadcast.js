var config = {
    openSocket: function(config) {
        // http://socketio-over-nodejs.hp.af.cm/
        // http://socketio-over-nodejs.jit.su:80/
        // http://webrtc-signaling.jit.su:80/

        var SIGNALING_SERVER = 'http://webrtc-signaling.jit.su:80/',
        defaultChannel = location.hash.substr(1) || 'webrtc-oneway-broadcasting';

        var channel = config.channel || defaultChannel;
        var sender = Math.round(Math.random() * 999999999) + 999999999;

        io.connect(SIGNALING_SERVER).emit('new-channel', {
            channel: channel,
            sender: sender
        });

        var socket = io.connect(SIGNALING_SERVER + channel);
        socket.channel = channel;
        socket.on('connect', function() {
            if (config.callback) config.callback(socket);
        });

        socket.send = function(message) {
            socket.emit('message', {
                sender: sender,
                data: message
            });
        };

        socket.on('message', config.onmessage);
    },
    onRemoteStream: function(htmlElement) {
        htmlElement.setAttribute('controls', true);
        videosContainer.insertBefore(htmlElement, videosContainer.firstChild);
        htmlElement.play();
    },
    onRoomFound: function(room) {
        var alreadyExist = document.querySelector('button[data-broadcaster="' + room.broadcaster + '"]');
        if (alreadyExist) return;

        var tr = document.createElement('tr');
        tr.innerHTML = '<td><strong>' + room.roomName + '</strong> is broadcasting his media!</td>' +
            '<td><button class="join">Join</button></td>';
        roomsList.insertBefore(tr, roomsList.firstChild);

        var joinRoomButton = tr.querySelector('.join');
        joinRoomButton.setAttribute('data-broadcaster', room.broadcaster);
        joinRoomButton.setAttribute('data-roomToken', room.broadcaster);
        joinRoomButton.onclick = function() {
            this.disabled = true;

            var broadcaster = this.getAttribute('data-broadcaster');
            var roomToken = this.getAttribute('data-roomToken');
            broadcastUI.joinRoom({
                roomToken: roomToken,
                joinUser: broadcaster
            });
        };
    },
    onNewParticipant: function(numberOfViewers) {
        document.title = 'Viewers: ' + numberOfViewers;
    }
};


var broadcastUI = broadcast(config);

var videosContainer = document.getElementById('videos-container') || document.body;
var setupNewBroadcast = document.getElementById('setup-new-broadcast');
var roomsList = document.getElementById('rooms-list');
var broadcastingOption = document.getElementById('broadcasting-option');

document.getElementById('broadcasting-option').onclick = function() {
    this.disabled = true;

    captureUserMedia(function() {
        var shared = 'video';
        if (window.option == 'Only Audio') shared = 'audio';
        if (window.option == 'Screen') shared = 'screen';
        broadcastUI.createRoom({
            roomName: 'Anonymous',
            isAudio: shared === 'audio'
        });
    });
};

function captureUserMedia(callback) {
    var constraints = null;
    window.option = broadcastingOption ? broadcastingOption.value : '';
    if (option === 'Only Audio') {
        constraints = {
            audio: true,
            video: false
        };
    }
    if (option === 'Screen') {
        var video_constraints = {
            mandatory: {
                chromeMediaSource: 'screen'
            },
            optional: []
        };
        constraints = {
            audio: false,
            video: video_constraints
        };
    }

    var htmlElement = document.createElement(option === 'Only Audio' ? 'audio' : 'video');
    htmlElement.setAttribute('autoplay', true);
    htmlElement.setAttribute('controls', true);
    videosContainer.insertBefore(htmlElement, videosContainer.firstChild);

    var mediaConfig = {
        video: htmlElement,
        onsuccess: function(stream) {
            config.attachStream = stream;
            htmlElement.setAttribute('muted', true);
            callback();
        },
        onerror: function() {
            if (option === 'Only Audio') alert('unable to get access to your microphone');
            else if (option === 'Screen') {
                if (location.protocol === 'http:') alert('Please test this WebRTC experiment on HTTPS.');
                else alert('Screen capturing is either denied or not supported. Are you enabled flag: "Enable screen capture support in getUserMedia"?');
            } else alert('unable to get access to your webcam');
        }
    };
    if (constraints) mediaConfig.constraints = constraints;
    getUserMedia(mediaConfig);
}
