/*
 * MenuButton.fx
 *
 * Created on 15-Mar-2010, 15:55:06
 */

package zen.like;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.Node;
import javafx.scene.layout.Resizable;
import javafx.scene.layout.Container;
import javafx.scene.shape.Ellipse;
import javafx.scene.input.MouseEvent;

/**
 * Menubutton component
 * @author Peter Pilgrim at the Java Posse Roundup 2010
 */
public abstract class AbstractMenuButton extends CustomNode, Resizable {

    override var width = 64  on replace {
        computeLayout();
    }
    override var height = 64 on replace {
        computeLayout();
    }
    /** margin size */
    public var margin: Number = 4 on replace {
        computeLayout();
    };

    /** action event */
    public var onAction: function(): Void;


    /** background of the icon */
    public var background: Color = Color.WHITE;
    /** icon color when mouse hovers over the button */
    public var hoverColor: Color = Color.GREY;
    /** icon color when mouse button is pressed */
    public var downColor: Color = Color.LIGHTBLUE;

    /** the border size of the icon ellipse */
    public var borderWidth: Number = 2;
    /** the border colour of the icon ellipse */
    public var borderColor: Color = Color.BLACK;

    /** The icon face */
    protected var faceNode: Node on replace {
        if ( isInitialized(faceNode)) {
            computeLayout();
        }
    };

    protected var backNode: Ellipse;
    protected var faceClipperNode: Ellipse = Ellipse{};
    
    public override function create(): Node {
        faceNode = createIconFaceNode();
        return Group {

            onMouseClicked: function (e: MouseEvent): Void {
                fireAction();
            }
            onMousePressed: function (e: MouseEvent): Void {
                backNode.fill = downColor;
            }
            onMouseReleased: function (e: MouseEvent): Void {
                backNode.fill = if (hover) hoverColor else background;
            }
            onMouseEntered: function (e: MouseEvent): Void {
                backNode.fill = hoverColor;
            }
            onMouseExited: function (e: MouseEvent): Void {
                backNode.fill = background;
            }

            content: [
                backNode = Ellipse {
                    centerX: bind width/2, centerY: bind height/2
                    radiusX: bind width/2, radiusY: bind height/2
                    fill: background
                    stroke: bind borderColor
                    strokeWidth: bind borderWidth
                },
                Group {
                    clip: faceClipperNode
                    content: faceNode
                }
            ]
        };
    }

    public abstract function createIconFaceNode(): Node;

    protected function computeLayout(): Void {

        var itemWidth  = width - 2*margin;
        var itemHeight = height - 2*margin;
        Container.layoutNode(faceNode, margin, margin, itemWidth, itemHeight);

        // Create the clipper
        faceClipperNode.centerX = itemWidth / 2 + margin;
        faceClipperNode.centerY = itemHeight / 2 + margin;
        faceClipperNode.radiusX = itemWidth / 2;
        faceClipperNode.radiusY = itemHeight / 2;

    }

    protected function fireAction(): Void {
        if ( onAction != null) {
            onAction();
        }

    }

    public override function getPrefWidth(height: Number) : Number
    {
        return if ( width > 0) width else -1
    }

    public override function getPrefHeight(width: Number) : Number
    {
        return if ( height > 0) height else -1
    }

}

// Github commands
// Never going remember// git pull dickwallrepo master
// git pull dickwallrepo master
// git pull
// git push
// git push origin master
//

