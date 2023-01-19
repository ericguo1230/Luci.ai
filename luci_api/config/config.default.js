/* eslint valid-jsdoc: "off" */

'use strict';

/**
 * @param {Egg.EggAppInfo} appInfo app info
 */
module.exports = appInfo => {
  /**
   * built-in config
   * @type {Egg.EggAppConfig}
   **/
  const config = exports = {};

  // use for cookie sign key, should change to your own and keep security
  config.keys = appInfo.name + '_1660243942428_7664';

  // add your middleware config here
  config.middleware = [];

  // add your user config here
  const userConfig = {
    // myAppName: 'egg',
  };

 config.security = {
  methodnoallow: {
    enable: false,
  },
  domainWhiteList: [
    ','
  ],
  csrf: {
    enable: true,
    ignore: ctx => {
      return ctx.path.startsWith('/api');
    },
  },
 };

  return {
    ...config,
    ...userConfig,
  };
};
