import React from "react"
import {HttpLink} from 'apollo-link-http';
import ApolloClient from 'apollo-client';
import {createApp} from '@shopify/app-bridge';
import { Redirect } from '@shopify/app-bridge/actions';
import {SessionToken} from '@shopify/app-bridge/actions';
import {InMemoryCache, defaultDataIdFromObject} from 'apollo-cache-inmemory';

import {getRootElement, getEmbeddedAppProps} from '../utilities/';

const root = getRootElement();

const embeddedAppProps = getEmbeddedAppProps();
const apiKey = getEmbeddedAppProps && embeddedAppProps.apiKey;
const shopOrigin = getEmbeddedAppProps && embeddedAppProps.shopOrigin;

const app = createApp({
  apiKey: apiKey,
  shopOrigin: shopOrigin
});

const cache = new InMemoryCache({
  dataIdFromObject: (object) => {
    switch (object.__typename) {
      case 'ButtonSettings':
        return 'ButtonSettings';
      default:
        return defaultDataIdFromObject(object);
    }
  },
});

const customFetch = async (uri, options) => {
  app.dispatch(SessionToken.request());
  const optionsWithToken = await new Promise((resolve) => {
    app.subscribe(SessionToken.ActionType.RESPOND, (payload) => {
      resolve({
        ...options,
        headers: {
          Authorization: `Bearer ${payload.sessionToken}`,
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      });
    });
  });
  return fetch(uri, optionsWithToken);
};

const link = new HttpLink({
  credentials: 'same-origin',
  fetch: customFetch,
});

const client = new ApolloClient({
  link,
  cache,
});

customFetch('/graphql');

export default function App () {
  return(<h1>App</h1>)
}

