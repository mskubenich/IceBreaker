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
                .state('edit_profile',{
                    url: '/user/edit_profile',
                    templateUrl: 'application/templates/users/edit_profile.html',
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
                .state('logout_all',{
                    url: '/logout_all',
                    templateUrl: 'application/templates/sessions/logout_all.html',
                    controller: 'SessionsController'
                })
                .state('forgot_password',{
                    url: '/forgot_password',
                    templateUrl: 'application/templates/passwords/forgot_password.html',
                    controller: 'PasswordsController'
                })
                .state('feedback',{
                    url: '/feedback',
                    templateUrl: 'application/templates/feedback/new.html',
                    controller: 'FeedbackController'
                })
                .state('search',{
                    url: '/search',
                    templateUrl: 'application/templates/search/index.html',
                    controller: 'SearchController'
                })
                .state('set_location',{
                    url: '/set_location',
                    templateUrl: 'application/templates/location/update.html',
                    controller: 'LocationController'
                })
                .state('reset_location',{
                    url: '/reset_location',
                    templateUrl: 'application/templates/location/destroy.html',
                    controller: 'LocationController'
                })
                .state('unread_messages',{
                    url: '/unread_messages',
                    templateUrl: 'application/templates/messages/unread.html',
                    controller: 'MessagesController'
                })
    }]);

    IceApp.run(['$http', '$rootScope', function($http, $rootScope){

    }]);


}());