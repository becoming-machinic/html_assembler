# Html Assembler

_A transformer for pub._

## Develop your Single-page Application in logical html fragments and run it as a single html file.

I have created several single-page applications using AngularDart. After working on a project for a while, more and more time is spent looking for that specific element in a stack of elements. I have created this transformer to allow me to split my html into logical fragments during development, but work with it as a single file during debugging and production.

## How it works

This transformer can inline html fragments into the referencing div with an import attribute. The html file will then be processed by any additional transformers (such as AngularDart).

## Configuring

Add the dependencies to your pubspec.yaml

	dependencies:
	  html_assembler: ">=0.0.1 <0.1.0"

Add the transformer to your pubspec.yaml:

    transformers:
    - html_assembler
    
## Usage

Add a `import="fragment.html"` attribute to the div. Here is an example:

    <div import="fragment.html"></div>
    
Run `pub build` to build the application, or `pub serve` to run a development
server. In both cases, `pub` will inline the fragment.html file:
    
## Known issues

## Bugs/requests

Please report [bugs and feature requests][bugs].


[bugs]: https://github.com/becoming-machinic/html_assembler/issues
