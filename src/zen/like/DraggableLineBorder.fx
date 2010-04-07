/*
 * DraggableLineBorder.fx
 *
 * Created on 06-Apr-2010, 08:29:40
 */

package zen.like;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Cursor;
import javafx.scene.layout.Resizable;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.ext.swing.SwingComponent;
import javafx.scene.input.MouseEvent;
import javafx.util.Math;

def STEP=10;


/**
 * Draggable line boder
 * @author Peter
 */
public class DraggableLineBorder extends CustomNode, Resizable {

    public var margin: Number = 10 on replace {
        scheduleLayout();
    };

    public-init var item: Node;

    override var width on replace {
        scheduleLayout();
    }
    override var height on replace {
        scheduleLayout();
    }

    public var marginWidth: Number   = 10;
    public var marginHeight: Number  = 10;
    public var minimumWidth: Number  = 100;
    public var minimumHeight: Number = 100;
    public var maximumWidth: Number  = 700;
    public var maximumHeight: Number = 700;
    
    public var borderStrokeColor: Color = Color.BLACK;
    public var borderFillColor: Color = Color.TRANSPARENT;
    public var borderWidth: Number = 2;
    public var dragNodeSize: Number = 10 on replace {
        if ( isInitialized(dragNodeSize) ) {
            for ( dn in dragNodes) {
                dn.size = dragNodeSize;
            }
        }
    };


    protected var debugRect = Rectangle {
        width: bind width
        height: bind height
        fill: Color.web("#FFE0E0")
        stroke: Color.BLACK strokeWidth: 1
    };

    protected var border = Rectangle {
        strokeWidth: bind borderWidth;
        strokeDashOffset: 4
        strokeDashArray: [ 4, 8 ]
        stroke: bind borderStrokeColor;
        fill: bind borderFillColor;
    };

    protected var n = DragNode{id: "n", hoverCursor: Cursor.N_RESIZE };
    protected var ne = DragNode{id: "ne", hoverCursor: Cursor.NE_RESIZE };
    protected var e = DragNode{id: "e", hoverCursor: Cursor.E_RESIZE };
    protected var se = DragNode{id: "se", hoverCursor: Cursor.SE_RESIZE };
    protected var s = DragNode{id: "s", hoverCursor: Cursor.S_RESIZE };
    protected var sw = DragNode{id: "sw", hoverCursor: Cursor.SW_RESIZE };
    protected var w = DragNode{id: "w", hoverCursor: Cursor.W_RESIZE };
    protected var nw = DragNode{id: "nw", hoverCursor: Cursor.NW_RESIZE };
    protected var dragNodes: DragNode[] = [ n, ne, e, se, s, sw, w, nw ];

    /** Relayout flag */
    protected var needRelayout: Boolean;

    /** Reschedule a relayout on the EDT */
    protected function scheduleLayout(): Void {
        if ( not needRelayout) {
            needRelayout = true;
            FX.deferAction(  function(): Void {
                needRelayout = false;
                computeLayoutDown();
            });
        }
    }

    public override function create(): Node {
        for ( dn in dragNodes) {
            dn.size = dragNodeSize;
            dn.dragAction = dragListener;
        }
        computeLayoutDown();
        Group {
            content: [debugRect, border, dragNodes, item ];
        }
    }

    public override function getPrefWidth(height: Number) : Number
    {
        -1
    }

    public override function getPrefHeight(width: Number) : Number
    {
        -1
    }

    protected function computeLayoutDown(): Void {
        var itemWidth: Number  = width - 2*margin;
        var itemHeight: Number = height - 2*margin;
        Container.layoutNode(item, margin, margin, itemWidth, itemHeight);

        var w2 = width  / 2;
        var h2 = height / 2;
        var m2 = margin / 2;
        border.x = 0;
        border.y = 0;
        border.translateX = m2;
        border.translateY = m2;
        border.width  = width - margin;
        border.height = height - margin;

        positionDragNode(n,  w2,       m2 );
        positionDragNode(ne, width-m2, m2 );
        positionDragNode(e,  width-m2, h2 );
        positionDragNode(se, width-m2, height-m2 );
        positionDragNode(s,  w2,       height-m2 );
        positionDragNode(sw, m2,       height-m2 );
        positionDragNode(w,  m2,       h2 );
        positionDragNode(nw, m2,       m2 );
    }

    protected function positionDragNode( node: DragNode, x: Number, y: Number): Void {
        node.x = x;
        node.y = y;
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

    protected function positionBorder( x: Number, y: Number, w: Number, h: Number ): Void {
        var x2 = Math.max(x, marginWidth );
        var y2 = Math.max(y, marginHeight);
        var w2 = Math.max( Math.min(w, maximumWidth ), minimumWidth );
        var h2 = Math.max( Math.min(h, maximumHeight ), minimumHeight );
        this.layoutX = x2;
        this.layoutY = y2;
        this.width   = w2;
        this.height  = h2;
    }

    protected function dragListener( node: DragNode, deltaX: Number, deltaY: Number, e: MouseEvent): Void {
        println("node.id={%4s node.id} deltaX={%7.3f deltaX}, deltaY={%7.3f deltaY}, e={e}");
        if ( node.id.equals("nw")) {
            var xpos = this.layoutX + deltaX;
            var ypos = this.layoutY + deltaY;
            var newWidth  = this.width  + -deltaX;
            var newHeight = this.height + -deltaY;
            positionBorder( xpos, ypos, newWidth, newHeight );
        }
        else if ( node.id.equals("n")) {
            var ypos = this.layoutY + deltaY;
            var newHeight = this.height + -deltaY;
            positionBorder( layoutX, ypos, width, newHeight );
        }
        else if ( node.id.equals("ne") or node.id.equals("e")) {
            var newWidth  = e.x;
            positionBorder( layoutX, layoutY, newWidth, height );
        }
        else if ( node.id.equals("se")) {
            var newWidth  = e.x;
            var newHeight = e.y;
            positionBorder( layoutX, layoutY, newWidth, newHeight );
        }
        else if ( node.id.equals("s")) {
            var newHeight = e.y;
            positionBorder( layoutX, layoutY, width, newHeight );
        }
        else if ( node.id.equals("sw")) {
            var xpos = this.layoutX + deltaX;
            var newWidth  = this.width + -deltaX;
            var newHeight = e.y;
            positionBorder( xpos, layoutY, newWidth, newHeight );
        }
        else if ( node.id.equals("w")) {
            var xpos = this.layoutX + deltaX;
            var newWidth  = this.width + -deltaX;
            positionBorder( xpos, layoutY, newWidth, height );
        }
    }

}


/**
 * The rectangle
 */
protected class DragNode extends Rectangle {


    /** The sixe of the square */
    public var size: Number on replace {
        if ( isInitialized(size)) {
            width = size;
            height = size;
            translateX = translateY = -size / 2;
            // x = y = -size/2;
        }
    };

    override var stroke = Color.BLACK;
    override var strokeWidth = 1;
    override var blocksMouse = true;


    public var btnUpFill: Color = Color.LIGHTBLUE;
    public var btnHoverFill: Color = Color.ORANGE;
    public var btnDownFill: Color  = Color.GREEN;
    public var normalCursor: Cursor = Cursor.DEFAULT;
    public var hoverCursor: Cursor = Cursor.DEFAULT;

    public var dragAction: function( node: DragNode, deltaX: Number, deltaY: Number, e:MouseEvent ): Void;

    var buttonDown: Boolean;
    var startX: Number;
    var startY: Number;

    override var onMousePressed = function( e: MouseEvent ):Void {
        fill = btnDownFill;
        buttonDown = true;
        startX = e.x;
        startY = e.y;
    }

    override var onMouseReleased = function( e: MouseEvent ):Void {
        fill = btnUpFill;
        buttonDown = false;
    }

    override var onMouseEntered = function( e: MouseEvent ):Void {
        this.cursor = hoverCursor;
        fill = if ( buttonDown) btnDownFill else btnHoverFill;
    }

    override var onMouseExited = function( e: MouseEvent ):Void {
        this.cursor = normalCursor;
        fill = if ( buttonDown) btnDownFill else btnUpFill;
    }

    override var onMouseDragged = function( e: MouseEvent ):Void {
        if ( dragAction != null ) {
            var deltaX = e.x - startX ;
            var deltaY = e.y - startY ;
            dragAction( this, deltaX, deltaY, e );
        }

    }

    postinit {
        fill = btnUpFill;
    }

}


/**
 * A main entry program for testing this component visually
 */
public function run( args: String[] ): Void {
    var editor = TextEditor.create( Font{size: 22 name:"Courier New"},
    Color.BLUE, Color.RED, Color.BEIGE, function(): Void {} );
    (editor.node as SwingComponent).width = 400;
    (editor.node as SwingComponent).height = 400;

    editor.setText("Noted Podcasts:-\n"
            "* TEDTalks\n"
            "* Buzz Out Loud\n"
            "* The Buzz Report\n"
            "* NPR: Wait Wait... Don't Tell Me! Podcast\n"
            "* This American Life\n"
            "* Stanford Entrepreneurial Thought Leaders\n" );

    Stage {
	title : "Testing DraggableLineBorder"
	scene: Scene {
            width: 800
            height: 600
            content: [
                DraggableLineBorder {
                    layoutX: 50
                    layoutY: 50
                    width: 400
                    height: 400
                    item: editor.node
                }
            ]
	}
    }
}
