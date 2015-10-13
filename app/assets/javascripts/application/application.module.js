(function () {
    "use strict";
    var IceApp = angular.module('IceApp', [
        'ui.router',
        'templates',
        'ngDialog',
        'validation.match',
        'validation.email',
        'fileread',
        'ui.bootstrap',
        'bootstrapLightbox',
        'ui-rangeSlider',
        'redactor',
        'formInput.images',
        'formInput.image',
        'hljs'
    ]);

    IceApp.config(['$urlRouterProvider', '$stateProvider', '$httpProvider', 'hljsServiceProvider',
        function ($urlRouterProvider, $stateProvider, $httpProvider, hljsServiceProvider) {
            //hljsServiceProvider.setOptions({
            //    // replace tab with 4 spaces
            //    tabReplace: '    '
            //});

            $httpProvider.defaults.headers.common['X-Requested-With'] = 'AngularXMLHttpRequest';

            $urlRouterProvider.otherwise('home');

            $stateProvider
                .state('home',{
                    url: '',
                    templateUrl: 'application/templates/home/index.html',
                    controller: 'HomeController'
                })
                .state('new_user',{
                    url: '/user/new',
                    templateUrl: 'application/templates/users/form.html',
                    controller: 'UsersController'
                })
                .state('login',{
                    url: '/login',
                    templateUrl: 'application/templates/sessions/login.html',
                    controller: 'SessionsController'
                })
                .state('login_with_facebook',{
                    url: '/login_with_facebook',
                    templateUrl: 'application/templates/sessions/login_with_facebook.html',
                    controller: 'SessionsController'
                })
                .state('logout',{
                    url: '/logout',
                    templateUrl: 'application/templates/sessions/logout.html',
                    controller: 'SessionsController'
                })
    }]);

    IceApp.run(['$http', '$rootScope', function($http, $rootScope){

    }]);


}());