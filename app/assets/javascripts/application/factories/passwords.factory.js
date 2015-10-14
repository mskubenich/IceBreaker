(function () {
    'use strict';
    angular.module('IceApp').factory('PasswordsFactory', ['$http', function($http){
        return {

            forgot_password: function(user){
                var fd = new FormData();

                fd.append('email', user.email );

                return $http.post('/api/v1/passwords', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            }
        }
    }])
}());