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
            }
        }
    }])
}());