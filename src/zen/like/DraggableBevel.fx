/*
 * DraggableBevel.fx
 *
 * Created on 08-Apr-2010, 19:05:48
 */

package zen.like;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Cursor;
import javafx.scene.layout.Resizable;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.ShapeSubtract;
import javafx.scene.input.MouseEvent;
import javafx.animation.transition.FadeTransition;

def MIN_OPACITY=0.33;
def MAX_OPACITY=0.85;

/**
 * A draggable bevel component that is form from a {@link ShapeSubstract}, which consists of an outer rectangle
 * A substracted from an inner rectangle B. The custom node has fade transition animation effects applied
 * when the mouse enters and exits the component. The opacities are user configurable.
 * <p>
 * 
 * A user can listen to drag position by registering a function type callback on {@link #dragAction()}
 *
 * @author Peter Pilgrim
 */
public class DraggableBevel extends CustomNode, Resizable {

    /** The bevel width */
    public var bevelWidth: Number = 10;

    /** The bevel height */
    public var bevelHeight: Number = 10;

    public var btnUpFill: Color = Color.LIGHTBLUE;
    public var btnHoverFill: Color = Color.ORANGE;
    public var btnDownFill: Color  = Color.GREEN;
    public var normalCursor: Cursor = Cursor.DEFAULT;
    public var hoverCursor: Cursor = Cursor.CROSSHAIR;

    public var minimumOpacity: Number = MIN_OPACITY;
    public var maximumOpacity: Number = MAX_OPACITY;

    public var dragAction: function( node: DraggableBevel, deltaX: Number, deltaY: Number, e:MouseEvent ): Void;

    protected var buttonDown: Boolean;
    protected var startX: Number;
    protected var startY: Number;

    protected var shape: ShapeSubtract;

    protected var fadeTx: FadeTransition;

    override function create(): Node {
        var group = Group {
            content: [
                shape = ShapeSubtract {
                    // We bind on the object, because we want to force
                    // ShapeSubstract to resize on a dimension change.
                    // Every time the width and/or height
                    // changes a new Rectangle scenegraph object is created.
                    // *PP* 09/Apr/2010
                    a: bind Rectangle {
                        width:  width
                        height: height
                    };
                    b: bind Rectangle {
                        translateX: bevelWidth
                        translateY: bevelHeight
                        width:  this.width - bevelWidth*2
                        height: this.height - bevelHeight*2
                    };
                    fill: btnUpFill
                    opacity: minimumOpacity
                }
            ]
        };

        return group;
    }

    public override function getPrefWidth(height: Number) : Number
    {
        -1
    }

    public override function getPrefHeight(width: Number) : Number
    {
        -1
    }

    override var onMousePressed = function( e: MouseEvent ):Void {
        shape.fill = btnDownFill;
        buttonDown = true;
        startX = e.x;
        startY = e.y;
    }

    override var onMouseReleased = function( e: MouseEvent ):Void {
        shape.fill = btnUpFill;
        buttonDown = false;
    }

    override var onMouseEntered = function( e: MouseEvent ):Void {
        this.cursor = hoverCursor;
        shape.fill = if ( buttonDown) btnDownFill else btnHoverFill;

        fadeTx.stop();

        fadeTx = FadeTransition {
            node: shape
            fromValue: minimumOpacity
            toValue: maximumOpacity
            duration: 1s
        };
        fadeTx.playFromStart();
    }

    override var onMouseExited = function( e: MouseEvent ):Void {
        this.cursor = normalCursor;
        shape.fill = if ( buttonDown) btnDownFill else btnUpFill;
        fadeTx.stop();
        fadeTx = FadeTransition {
            node: shape
            fromValue: maximumOpacity
            toValue: minimumOpacity
            duration: 1s
        };
        fadeTx.playFromStart();
    }

    override var onMouseDragged = function( e: MouseEvent ):Void {
        if ( dragAction != null ) {
            var deltaX = e.x - startX ;
            var deltaY = e.y - startY ;
            dragAction( this, deltaX, deltaY, e );
        }

    }
}

/**
 * A main entry program for testing this component visually
 */
public function run( args: String[] ): Void {

    var bevel: DraggableBevel;

    Stage {
	title : "Testing DraggableBevel"
	scene: Scene {
            width: 800
            height: 600
            content: [
                bevel = DraggableBevel {
                    layoutX: 50
                    layoutY: 50
                    width: 400
                    height: 400
                    dragAction: function( node: DraggableBevel, deltaX: Number, deltaY: Number, e:MouseEvent ): Void {
                        println("deltaX={deltaX}, deltaY={deltaY}, e={e}");
                        bevel.layoutX += deltaX;
                        bevel.layoutY += deltaY;
                    }
                }
            ]
	}
    }
}
