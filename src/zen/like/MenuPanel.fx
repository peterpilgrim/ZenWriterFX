/*
 * MenuPanel.fx
 *
 * Created on Mar 15, 2010, 3:14:37 PM
 */

package zen.like;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.layout.VBox;
import javafx.scene.control.Label;

/**
 * @author dick
 */

public class MenuPanel extends Group {

    public var x: Number;
    public var y: Number;
    public var width: Number;
    public var height: Number;

    override var opacity = 1.0;
    override var onMouseEntered = function(e) {
        Timeline {
            repeatCount: 1
            keyFrames : [
                KeyFrame {
                    time : 0.5s
                    canSkip : true
                    values: opacity => 1
                }
            ]
        }.play();
    }

    override var onMouseExited = function(e) {
        Timeline {
            repeatCount: 1
            keyFrames : [
                KeyFrame {
                    time : 0.5s
                    canSkip : true
                    values: opacity => 0
                }
            ]
        }.play();
    }

    var rectangle = Rectangle {
        fill: Color.WHITE
        x: bind x
        y: bind y
        width: bind width
        height: bind height
        opacity: 0.5
    }

    public var saveButton: WorkMenuButton;
    public var workButton: WorkMenuButton;

    def MARGIN=3;

    postinit {
        content = [

            rectangle,
            VBox {
                spacing: 5
                layoutX: bind x+MARGIN;
                layoutY: bind y+MARGIN;
                width: bind width-2*MARGIN;
                height: bind height-2*MARGIN;
                content: [
                    workButton = WorkMenuButton{ content: "W" },
                    saveButton = WorkMenuButton{ content: "S" },

                ]
            }
        ]
    }


}
