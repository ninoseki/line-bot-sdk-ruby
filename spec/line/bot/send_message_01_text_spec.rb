require 'spec_helper'
require 'webmock/rspec'
require 'json'

WebMock.allow_net_connect!

describe Line::Bot::Client do
  it 'pushes the text message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/push'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    user_id = 'user_id'
    message = {
      type: 'text',
      text: 'Hello, world'
    }
    response = client.push_message(user_id, message)

    expected = {
      to: user_id,
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'replies the text message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/reply'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    reply_token = 'reply_token'
    message = {
      type: 'text',
      text: 'Hello, world'
    }
    response = client.reply_message(reply_token, message)

    expected = {
      replyToken: reply_token,
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'multicasts the text message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/multicast'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    user_ids = ['user1', 'user2']
    message = {
      type: 'text',
      text: 'Hello, world'
    }
    response = client.multicast(user_ids, message)

    expected = {
      to: user_ids,
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end

  it 'broadcasts the text message' do
    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/broadcast'
    stub_request(:post, uri_template).to_return { |request| {body: request.body, status: 200} }

    client = Line::Bot::Client.new do |config|
      config.channel_token = 'channel_token'
    end

    message = {
      type: 'text',
      text: 'Hello, world'
    }
    response = client.broadcast(message)

    expected = {
      messages: [
        message
      ]
    }.to_json
    expect(response.body).to eq(expected)
  end
end
