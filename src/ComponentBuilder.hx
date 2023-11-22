package;

import haxe.macro.Expr;
import haxe.macro.Context;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;

class ComponentBuilder {
 
  // A macro function that adds easy functions for compile time
  // adding children 
  public static macro function withChildren(object:Expr, children:Expr ):Expr {
    var tempVar = genTempVar();

    var expressions : Array<Expr> = [];
    switch(children.expr) {
      case EArrayDecl(values):
        for(value in values) {
          expressions.push(macro { $p{[tempVar]}.addChild($value); });
        }
      default:
    }

    return macro {
      var $tempVar = $object;
      $b{expressions};
      $p{[tempVar]};
    };
  }

  private static function _fieldsToMacro(expr:Expr, fields:Array<ObjectField>) :Expr {
    var varName :String = genTempVar();
    var expressions : Array<Expr> = [];

    for(field in fields) {
      var fieldName = field.field;
      var fieldExpr = field.expr;
      expressions.push(macro {
        $p{[varName,fieldName]} = $fieldExpr;
      });
    }

    return macro {
      var $varName = $expr;
      $b{expressions}
      $p{[varName]}; 
    };
  }

  // Helper functions for generating unique temporary variables
  private static var tempIndex = 0;
  private static function genTempVar() {
    return '__COMPONENT_BUILDER__tmp_${tempIndex++}';
  }

  // A macro function that adds easy functions for compile time
  // changing fields.
  // Intended to be used with the withChildren function
  public static macro function withFields(expr:Expr, fields:Expr) :Expr {
    return 
      _fieldsToMacro(expr,
          switch(fields.expr) {
            case EObjectDecl(fields):
              fields;
            case type:
              Context.error('fields are of invalid type \'$type\'', Context.currentPos());
          });
  }

  // Convert Call Expressions to Fields
  private static function _callExprToField(tempVar:String, expr:Expr) :Expr {
    switch(expr.expr) {
      case EConst(c):
        switch(c) {
          case CIdent(id):
           return {
             pos: Context.currentPos(),
             expr: EField(macro $p{[tempVar]}, id)
           };
          case c:
           throw 'invalid constant $c';
        }
      case c:
        throw 'invalid call expressions $c';
    } 
  }

  // Convert expressions for apply functions
  private static function _funcExprToCall(tempVar:String, fn:Expr) :Expr {
    switch(fn.expr) {
      case ECall(c, params):
        return {
          pos : Context.currentPos(),
          expr : ECall(_callExprToField(tempVar, c), params)
        }
      case c:
        throw '$c needs to be a constant expression';
    }
  }

  // Allows you to apply functions to expressions at compile time
  public static macro function apply(expr:Expr, funcs:Array<Expr>) :Expr {
    var tempVar = genTempVar();
    var expressions = [];
    for(fn in funcs) {
      expressions.push(_funcExprToCall(tempVar, fn));
    }
    return macro {
      var $tempVar = $expr;
      $b{expressions};
      $p{[tempVar]};
    };
  }
}
