(function () {

    "use strict";

    angular.module('IceApp')
        .controller('HomeController', ['$scope', '$state', 'ngDialog', function ($scope, $state, ngDialog) {
            $scope.I18n = I18n;
            $scope.$state = $state;

        }])
}());