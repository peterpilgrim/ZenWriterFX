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
import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import zen.like.LineBorder;

/** Default initial screen width */
def DEFAULT_WIDTH=800;
/** Default initial screen height */
def DEFAULT_HEIGHT=600;


public function run(args: String[]) {
    def themeName = if (sizeof args == 0) Theme.DEFAULT else args[0];
    def theme = Theme.getTheme(themeName);
    if (theme == null) {
        println("No such theme: {themeName}");
        println("Available names: {Theme.getNames()}");
        FX.exit();
    }

    var scene: Scene;
    def keyTyped = function(): Void {
        theme.playClick();
    }
    def menuPanel = MenuPanel {};
    def editor = TextEditor.create(theme.font, theme.textColor, theme.selectionColor, theme.selectionTextColor, keyTyped);
    def editorNode: SwingComponent = editor.node as SwingComponent;
    editor.load(true);

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

    def bgPlayer = MediaPlayer {
        volume: 0.5
        media: Media {
            source: Utilities.makeLocal("{__DIR__}sounds/background/OceanWave.wav");
        }
        autoPlay: true
        repeatCount: MediaPlayer.REPEAT_FOREVER
        onError: function(e) {
            println(e);
        }
    }


    def stage: Stage = Stage {
        fullScreen: true
        width: DEFAULT_WIDTH
        height: DEFAULT_HEIGHT
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
    };
    
    editorNode.requestFocus();

    Utilities.addShutdown(Application { editor: editor });
}
