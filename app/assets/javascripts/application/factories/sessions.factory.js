(function () {
    'use strict';
    angular.module('IceApp').factory('SessionsFactory', ['$http', function($http){
        return {

            login: function(session){
                var fd = new FormData();

                fd.append('login', session.login );
                fd.append('password', session.password );

                return $http.post('/api/v1/sessions', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            },

            logout: function(headers){
                var fd = new FormData();

                fd.append('session_token', headers.session_token );

                return $http.delete('/api/v1/sessions', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());