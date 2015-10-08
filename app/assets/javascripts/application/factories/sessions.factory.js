(function () {
    'use strict';
    angular.module('IceApp').factory('SessionsFactory', ['AuthHttp', function($http){
        return {
            check: function(){
                return $http.get('/sessions/check');
            }
        }
    }])
}());