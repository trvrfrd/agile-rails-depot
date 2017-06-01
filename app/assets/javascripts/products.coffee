# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App.products = App.cable.subscriptions.create 'ProductsChannel',
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    $('.store #main').html(data.html)
    $('.updated-product')
      .css({'background-color': '#8f8'})
      .animate({'background-color': 'white'}, 1000);
