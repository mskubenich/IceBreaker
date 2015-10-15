(function () {

    "use strict";

    angular.module('IceApp')
        .controller('LocationController', ['$scope', '$state', 'ngDialog', '$stateParams', '$timeout', '$sce', 'LocationFactory',
            function ($scope, $state, ngDialog, $stateParams, $timeout, $sce, location) {
                $scope.I18n = I18n;
                $scope._ = _;
                $scope.$state = $state;

                $scope.getHtml = function(html){
                    return $sce.trustAsHtml(html);
                };

                if($state.current.name == 'set_location'){

                    $scope.location = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        location.set($scope.location)
                            .success(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                            .error(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                    };
                }

                if($state.current.name == 'reset_location'){

                    $scope.session = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        location.reset($scope.session)
                            .success(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                            .error(function(responce_data, code, headers, config){
                                $scope.response = {
                                    response: JSON.stringify(responce_data, null, 2),
                                    code: JSON.stringify(code, null, 2),
                                    headers: JSON.stringify(headers, null, 2),
                                    config: JSON.stringify(config, null, 2)
                                };
                                $scope.submited = true;
                                $scope.processing = false;
                            })
                    };
                }
            }])
}());