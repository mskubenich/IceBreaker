(function () {
    'use strict';
    angular.module('IceApp').factory('MessagesFactory', ['$http', function($http){
        return {

            unread: function(session){
                return $http.get('/api/v1/messages/unread?session_token=' + session.session_token);
            }
        }
    }])
}());