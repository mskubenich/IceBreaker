(function () {

    "use strict";

    angular.module('IceApp')
        .controller('PasswordsController', ['$scope', '$state', 'ngDialog', '$stateParams', '$timeout', '$sce', 'PasswordsFactory',
            function ($scope, $state, ngDialog, $stateParams, $timeout, $sce, passwords) {
                $scope.I18n = I18n;
                $scope._ = _;
                $scope.$state = $state;

                $scope.getHtml = function(html){
                    return $sce.trustAsHtml(html);
                };

                if($state.current.name == 'forgot_password'){

                    $scope.user = {};

                    $scope.submit = function(){

                        $scope.processing = true;
                        passwords.forgot_password($scope.user)
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