(function () {
    'use strict';
    angular.module('IceApp').factory('SearchFactory', ['$http', function($http){
        return {

            search: function(session){
                return $http.get('/api/v1/search?session_token=' +  session.session_token )
            }
        }
    }])
}());