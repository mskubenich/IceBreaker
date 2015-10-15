(function () {
    'use strict';
    angular.module('IceApp').factory('LocationFactory', ['$http', function($http){
        return {

            set: function(location){
                var fd = new FormData();

                fd.append('session_token', location.session_token );

                if(location.latitude){
                    fd.append('latitude', location.latitude );
                }
                if(location.longitude){
                    fd.append('longitude', location.longitude );
                }

                return $http.put('/api/v1/location', fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
            },

            reset: function(session){
                return $http.delete('/api/v1/location?session_token=' + session.session_token);
            }
        }
    }])
}());