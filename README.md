# Blog Using Jekyll

A blog about software ideas that I care about. Written using Jekyll.


## Getting Started

I'm following Jekyll's [installation instructions](https://jekyllrb.com/docs/installation/),
specifically for [Ubuntu Linux](https://jekyllrb.com/docs/installation/ubuntu/).


### System Setup

You need Ruby, bundler, and jekyll installed on your system.

Jekyll recommends installing:

```
$ sudo apt-get install ruby-full build-essential
```

Configure Ruby Gems to be installed as a user, not as root:

```
$ echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
$ echo 'export GEM_HOME=$HOME/gems' >> ~/.bashrc
$ echo 'export PATH=$HOME/gems/bin:$PATH' >> ~/.bashrc
$ source ~/.bashrc
```

Install bundler. This should *not* be installed to root directories:

```
$ gem install bundler
```

If you require root privileges, check and reload your `.bashrc`.

Jekyll remcommends installing itself to the system, but I've been
installing it locally using a Gemfile.


### Create Jekyll Site

Create a `.gitignore` file with:

```
.bundle
_site/
vendor/
```

Create a `Gemfile` with:

```
source 'https://rubygems.org'

# For just jekyll:
gem 'jekyll'
# gem '<your_theme>'

# For GitHub Pages:
# gem 'github-pages', group: :jekyll_plugins
```

Install locally:

```
$ bundle install --path vendor/bundle
```

I've been ignoring the post-build messages from `html-pipeline`.

Create `_config.yml`:

```
# Empty for now
```


## Serve Pages Locally

Serve your site with:

```
$ bundle exec jekyll serve
```


## Links

  * Jekyll's [syntax highlighter](https://github.com/jneen/rouge/wiki/List-of-supported-languages-and-lexers)
