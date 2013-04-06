---
layout: article
title: Tiny API with Nginx
summary: How to build a tiny REST API using Nginx, Memcached and GeoIP.
---

## tl;dr

As it turns out, [Nginx](http://nginx.com/) can be configured to act like a full fledged REST API. **No web application needed.**

## Background

We had the need for a tiny API and we figured that the problem 
was simple enough to be implemented inside of Nginx. The three requirements for the API was;

 1. Responses in JSON (and JSONP)
 2. Client country using GeoIP
 3. Data retrieved from Memcached

I recommend that you use the [OpenResty](http://openresty.org/)
(aka. ngx_openresty) bundle if you want to install Nginx, it
contains a few really good third party modules. I’m using five 
Nginx modules in this project;
  [Echo](http://wiki.nginx.org/HttpEchoModule),
  [GeoIP](http://wiki.nginx.org/HttpGeoIPModule),
  [Memc](http://wiki.nginx.org/HttpMemcModule),
  [RealIp](http://wiki.nginx.org/HttpRealIpModule) and
  [XSS](https://github.com/agentzh/xss-nginx-module).

## The complete nginx.conf

{% highlight nginx %}
worker_processes 4;
events {}

http {
  access_log    off;
  error_log     off;
  geoip_country /path/to/GeoIP.dat;

  server {
    listen            9999;
    real_ip_header    X-Real-IP;
    set_real_ip_from  127.0.0.1;

    location /redirect_ip {
      internal;
      set $memc_key 'redirect';
      memc_pass 127.0.0.1:11211;
    }

    location /loadbalancer.json {
      default_type "application/json";

      echo -n "{\"geoip_country_code\":\"$geoip_country_code\",";
      echo -n "\"redirect\":\"";
      echo_location -n /redirect_ip;
      echo -n "\"}";

      xss_get on;
      xss_callback_arg callback;
      xss_output_type 'application/x-javascript';
    }

    location /loadbalancer {
      if ($request_method != POST) { return 405; }

      allow 127.0.0.1;
      deny all;

      set $memc_key 'redirect';
      set $memc_cmd 'set';
      set $memc_value $arg_var;
      memc_pass 127.0.0.1:11211;
    }
  }
}
{% endhighlight %}

## Using the API

I like to use [cURL](http://curl.haxx.se/) when manually testing API's:

### Updating the “redirect” value in Memcached via the API

{% highlight ruby %}
curl -X POST http://0.0.0.0:9999/loadbalancer?var=10.0.0.5 
#=> STORED
{% endhighlight %}

### Retrieve the JSON

{% highlight ruby %}
curl -H "X-Real-IP: 213.115.122.2" \
http://0.0.0.0:9999/loadbalancer.json
#=> {"geoip_country_code":"SE", "redirect":"10.0.0.5"}
{% endhighlight %}

#### And if we want to use JSONP:

{% highlight ruby %}
curl -H "X-Real-IP: 213.115.122.2" \
http://0.0.0.0:9999/loadbalancer.json?callback=foo
#=> foo({"geoip_country_code":"SE", "redirect":"10.0.0.5"});
{% endhighlight %}
