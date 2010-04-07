/*
 * LineBorder.fx
 *
 * Created on 15-Mar-2010, 12:36:56
 */

package zen.like;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.Resizable;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.ext.swing.SwingComponent;

def STEP=10;

/**
 * Line border component
 * @author Peter Pilgrim at the Java Posse Roundup 2010
 */

public class LineBorder extends CustomNode, Resizable {

    public var margin: Number = 10 on replace {
        computeLayoutDown();
    };

    public-init var item: Node;

    override var width on replace {
        computeLayoutDown();
    }
    override var height on replace {
        computeLayoutDown();
    }

    public var borderStrokeColor: Color = Color.BLACK;
    public var borderFillColor: Color = Color.TRANSPARENT;
    public var borderWidth: Number = 2;


    var border = Rectangle {
        strokeWidth: bind borderWidth;
        strokeDashOffset: 4
        strokeDashArray: [ 4, 8 ]
        stroke: bind borderStrokeColor;
        fill: bind borderFillColor;
    };

    public override function create(): Node {
        Group {
            content: [border, item ];
        }
    }

    protected function computeLayoutDown(): Void {
        border.width = width;
        border.height = height;
        var itemWidth: Number  = width - 2*margin;
        var itemHeight: Number = height - 2*margin;
        Container.layoutNode(item, margin, margin, itemWidth, itemHeight);
    }


    protected function computeLayoutUp(): Void {
        var itemWidth: Number;
        var itemHeight: Number;

        if ( item instanceof SwingComponent ) {
            itemWidth  = (item as SwingComponent).width;
            itemHeight = (item as SwingComponent).height;
        }
        else if ( item instanceof Resizable ) {
            itemWidth  = (item as Resizable).width;
            itemHeight = (item as Resizable).height;
        }

        // Container.layoutNode(item, margin, margin, itemWidth, itemHeight);
        border.width  = itemWidth  + margin*2;
        border.height = itemHeight + margin*2 ;
//        FX.println("computeLayout width={width}, height={height}, itemWidth={itemWidth}, itemHeight={itemHeight}, item.layout={item.layoutBounds}");
    }


    public override function getPrefWidth(height: Number) : Number
    {
        -1
    }

    public override function getPrefHeight(width: Number) : Number
    {
        -1
    }


}

/**
 * A main entry program for testing this component visually
 */
public function run( args: String[] ): Void {
    var editor = TextEditor.create( Font{size: 32 name:"Courier New"}, 
    Color.BLUE, Color.RED, Color.BEIGE, function(): Void {} );
    (editor.node as SwingComponent).width = 400;
    (editor.node as SwingComponent).height = 400;

    Stage {
	title : "Testing LineBorder"
	scene: Scene {
            width: 800
            height: 600
            content: [
                LineBorder {
                    width: 400
                    height: 400
                    item: editor.node
                }
            ]
	}
    }
}

// End.
