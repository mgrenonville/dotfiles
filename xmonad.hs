import qualified Data.Map as M
import System.IO
import XMonad
import XMonad.Layout.Accordion
import XMonad.Layout.PerWorkspace
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.StackSet as W

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0000BE"
 

myWorkspaces = ["IDE","web","dev","servers","pidgin","xchat","ooo","other","firebird","squirrel","chrome","skype","vm"]

full = noBorders Full

layouts =  onWorkspaces ["eclipse"] (full ||| avoidStruts (Mirror tiled) ) $  
            onWorkspaces  ["jboss","dev"] ( avoidStruts ( tiled ||| Mirror tiled |||  Accordion)) $
	    avoidStruts ( tiled ||| Mirror tiled ||| full ) ||| full
  where
 -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 -- The default number of windows in the master pane
     nmaster = 1
 -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
myLayoutHook = (toggleLayouts $ avoidStruts full) $ ( layouts )


myManageHook = composeAll
    [ className =? "MPlayer"          --> doFloat
    , title =? "GNU Image Manipulation Program" --> doFloat
    , title =? "GIMP"                  --> doFloat
    , title     =? "VLC media player" --> doFloat
    , className =? "Firefox"          --> doF (W.shift "web" )
    , className =? "Pidgin"           --> doF (W.shift "pidgin" )
    , className =? "Xchat"           --> doF (W.shift "xchat" )
    , className =? "net-sourceforge-squirrel_sql-client-Main"           --> doF (W.shift "squirrel" )
    ]

    


newKeys x = M.union (M.fromList (myKeys x)) (keys azertyConfig x)
myKeys conf@(XConfig {XMonad.modMask = modMask}) =
    [ ((modMask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")
-- Allow full screen mode
    , ((modMask, xK_f ), sendMessage ToggleLayout)
-- Return to last workspace
    , ((modMask ,  xK_b ), toggleWS )
    , ((modMask  , xK_Left  ), prevWS )
    , ((modMask  , xK_Right ), nextWS )
    , ((modMask              , xK_BackSpace), focusUrgent)
    ]
    ++
    --
    -- mod-{z,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{z,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (workspaces conf) numAzerty,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

numAzerty = [0xb2,0x26,0xe9,0x22,0x27,0x28,0x2d,0xe8,0x5f,0xe7,0xe0,0x29,0x3d]

main = do
--      xmproc <- spawnPipe "xmobar"
      xmonad $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }  $ azertyConfig {
                          manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig,
                          keys = newKeys,
                          modMask = mod4Mask,
                          normalBorderColor  = myNormalBorderColor,
                          focusedBorderColor = myFocusedBorderColor,
                          layoutHook = myLayoutHook,
                          startupHook = setWMName "LG3D",
                          terminal = "urxvt",
                          workspaces = myWorkspaces,
                          logHook =  updatePointer (Relative 0.5 0.5) >> takeTopFocus
--  Use this hook in order to activate xmobar
-- (dynamicLogWithPP $ xmobarPP
--                                    { ppOutput = hPutStrLn xmproc
--                                    , ppCurrent = xmobarColor "#09F" "" . wrap "[" "]"
--                                    , ppTitle = xmobarColor "pink" "" . shorten 50
--                                    })
}
