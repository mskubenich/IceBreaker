(function () {

    "use strict";

    angular.module('IceApp')
        .controller('HomeController', ['$scope', '$state', 'ngDialog', 'SessionsFactory', function ($scope, $state, ngDialog, session) {
            $scope.I18n = I18n;

            session.check();
        }])
}());