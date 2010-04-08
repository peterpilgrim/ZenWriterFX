/*
 * WorkMenuButton.fx
 *
 * Created on 15-Mar-2010, 16:26:44
 */

package zen.like;

import javafx.scene.Node;
import javafx.scene.text.*;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;

/**
 * Working text node icon implementation
 * @author Peter Pilgrim at the Java Posse Roundup 2010
 */

public class WorkMenuButton extends AbstractMenuButton {

    /** Text content */
    public var content: String = "W";

    public override function createIconFaceNode(): Node {
        Text {
            // *PP* 15/03/2010
            // Need to talk to Amy Fowler. This code is contradictory to visual inspection.
            // Trying to center the "W" in the middle of the circle.
            // I would have thought it was width/2 height/2 in FX 1.3 (TextOrigin.CENTER)
            translateX: bind width*0.25
            translateY: bind height*0.25
            font : Font {
                size: 24
            }
            textAlignment: TextAlignment.CENTER
            textOrigin: TextOrigin.BASELINE
            content: bind content;
        }
    }

}


/**
 * A main entry program for testing this component visually
 */
public function run( args: String[] ): Void {
    Stage {
	title : "Work Menu Button Helper"
	scene: Scene {
            width: 400
            height: 400
            fill: Color.web("#F0F0FF")
            content: [
                WorkMenuButton {
                    layoutX: 150 layoutY: 150
                    onAction: function(): Void {
                        println("******** Button Pressed *******");
                    }
                }
            ]

        }
    }

}

