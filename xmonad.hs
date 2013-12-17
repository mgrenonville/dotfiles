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
 


myWorkspaces = ["`","1","2","3","4","5","6","7","8","9","0","-","="]

full = noBorders Full

layouts =  onWorkspaces ["`"] (full ||| avoidStruts (Mirror tiled) ) $  
            onWorkspaces  ["2","3"] ( avoidStruts ( tiled ||| Mirror tiled |||  Accordion)) $
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
    , className =? "Iceweasel"          --> doF (W.shift "1" )
    , className =? "Pidgin"           --> doF (W.shift "5" )
    , className =? "jetbrains-idea"           --> doF (W.shift "`" )
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
   -- , ((0, xF86XK_AudioRaiseVolume),   spawn "amixer set Master 2%+")
    --, ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2%-")
    
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
        | (i, k) <- zip (workspaces conf) numQwerty,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (workspaces conf) numAzerty,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
-- keys between ² and = on an azerty keyboard. 13 worspaces.
numAzerty = [0xb2,0x26,0xe9,0x22,0x27,0x28,0x28,0xe8,0x5f,0xe7,0xe0,0x29,0x3d]

-- keys between ` and = on an qwerty keyboard. 13 worspaces.
numQwerty = [0x60,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x30,0x2d,0x3d]

main = do
      xmproc <- spawnPipe "xmobar"
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
                          logHook =  (dynamicLogWithPP $ xmobarPP
                                   { ppOutput = hPutStrLn xmproc
                                   , ppCurrent = xmobarColor "#09F" "" . wrap "[" "]"
                                   , ppTitle = xmobarColor "pink" "" . shorten 50
                                   }) >> updatePointer (Relative 0.5 0.5) >> takeTopFocus

}
