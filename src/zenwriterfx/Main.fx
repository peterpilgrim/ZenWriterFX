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
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.stage.Screen;
import zen.like.LineBorder;
import zen.like.DraggableLineBorder;

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
    def editor = TextEditor.create(theme.font, theme.textColor, theme.selectionColor, theme.selectionTextColor, keyTyped);
    def editorNode: SwingComponent = editor.node as SwingComponent;
    def lineBorder: DraggableLineBorder = DraggableLineBorder{ item: editorNode };
    editor.load(true);

    def menuPanel = MenuPanel {};

    editorNode.focusTraversable = true;

    var width: Number = bind stage.width on replace {
        lineBorder.width = width * (theme.endX - theme.beginX);
        lineBorder.translateX = width * theme.beginX;
        lineBorder.maximumWidth = stage.width - 20;
        menuPanel.x = width * theme.panelX;
        menuPanel.width = width * theme.panelWidth;
    };
    var height: Number = bind stage.height on replace {
        lineBorder.height = height * (theme.endY - theme.beginY);
        lineBorder.translateY = height * theme.beginY;
        lineBorder.maximumHeight = stage.height - 20;
        menuPanel.y = height * theme.panelY;
        menuPanel.height = height * theme.panelHeight;
    };

    if (theme.backgroundAudio != null) {
        // Start a timeline to initialize audio AFTER everything
        // else has come up
        Timeline {
            repeatCount: 1
            keyFrames: KeyFrame {
                time: 0.3s
                action: function() {
                    MediaPlayer {
                        volume: theme.backgroundAudioVolume
                        media: Media {
                            source: Utilities.makeLocal(theme.backgroundAudio);
                        }
                        autoPlay: true
                        repeatCount: MediaPlayer.REPEAT_FOREVER
                        onError: function(e) {
                            println(e);
                        }
                    }
                }
            }
        }.play();
    }

    def bounds = Screen.primary.bounds;
    def imageView =
        ImageView {
        opacity: 0
        fitWidth: bind width
        fitHeight: bind height
    }

    Timeline {
        repeatCount: 1
        keyFrames: [
            KeyFrame {
                time: 0.1s
                action: function() {
                    imageView.image = Image {
                        backgroundLoading: false
                        url: theme.backgroundImage
                    }

                    Timeline {
                        repeatCount: 1
                        keyFrames: [
                            KeyFrame {
                                time: 0.8s
                                values: imageView.opacity => theme.opacity
                            }
                        ]
                    }.play();
                }
            }
        ]
    }.play();

    def stage: Stage = Stage {
        fullScreen: true
        title: "ZenWriterFX"
        width: bounds.width
        height: bounds.height
        scene: scene = Scene {
            content: [
                imageView,
                lineBorder,
                menuPanel
            ]
            fill: theme.fill
        }
    }

    editorNode.requestFocus();
    Utilities.addShutdown(Application { editor: editor });
}
