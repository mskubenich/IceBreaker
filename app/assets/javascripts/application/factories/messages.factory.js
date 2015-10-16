(function () {
    'use strict';
    angular.module('IceApp').factory('MessagesFactory', ['$http', function($http){
        return {

            unread: function(session){
                return $http.get('/api/v1/messages/unread?session_token=' + session.session_token);
            },

            send: function(message){
                var fd = new FormData();

                fd.append('session_token', message.session_token ? message.session_token : '');
                fd.append('message', message.message ? message.message : '');
                fd.append('opponent_id', message.opponent_id ? message.opponent_id : '');
                return $http.post('/api/v1/messages', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());