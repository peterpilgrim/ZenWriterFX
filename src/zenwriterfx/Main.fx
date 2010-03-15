/*
 * Main.fx
 *
 * Created on Mar 15, 2010, 9:58:54 AM
 */
package zenwriterfx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import zen.like.TextEditor;
import javafx.ext.swing.SwingComponent;
import zen.like.MenuPanel;
import zen.like.LineBorder;

/**
 * @author dick
 */

var scene: Scene;
def theme = Theme.DEFAULT;
def keyTyped = function(): Void {
    theme.playClick();
}
def menuPanel = MenuPanel {};
def editor = TextEditor.create(theme.font, theme.textColor, theme.selectionColor, theme.selectionTextColor, keyTyped);
def editorNode: SwingComponent = editor.node as SwingComponent;

var lineBorder: LineBorder = LineBorder{ item: editorNode };


editorNode.focusTraversable = true;

var width: Number = bind stage.width on replace {
    lineBorder.width = width * (theme.endX - theme.beginX);
    lineBorder.translateX = width * theme.beginX;
    menuPanel.x = width * theme.panelX;
    menuPanel.width = width * theme.panelWidth;
};
var height: Number = bind stage.height on replace {
    lineBorder.height = height * (theme.endY - theme.beginY);
    lineBorder.translateY = height * theme.beginY;
    menuPanel.y = height * theme.panelY;
    menuPanel.height = height * theme.panelHeight;
};

def stage: Stage = Stage {
    fullScreen: true
    title: "ZenWriterFX"
    scene: scene = Scene {
        content: [
            ImageView {
                opacity: theme.opacity
                image: Image {
                    backgroundLoading: true
                    url: theme.backgroundImage
                }
                fitWidth: bind width
                fitHeight: bind height
            }

            lineBorder,
            menuPanel
        ]
        fill: theme.fill
    }
}

editorNode.requestFocus();
