import qualified Data.Map as M

import XMonad.Prompt
import XMonad.Prompt.Ssh


import System.IO
import XMonad
import XMonad.Layout.Accordion
import XMonad.Layout.PerWorkspace
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
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
import XMonad.Actions.Plane
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86
import XMonad.Prompt
import XMonad.Prompt.Window

import XMonad.Actions.TagWindows

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0000BE"


devWorkspaces = ["`","1","2","3","4","5","6","7","8","9","0","-","="]
prodWorkspaces = ["p`","p1","p2","p3","p4","p5","p6","p7","p8","p9","p0","p-","p="]

myWorkspaces = devWorkspaces ++ prodWorkspaces 

full = noBorders Full

layouts =  onWorkspaces ["`"] ((full ||| tiled) ||| tabbed shrinkText defaultTheme ||| avoidStruts (Mirror tiled) ) $  
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


newKeys x = M.union (M.fromList (myKeys x)) (keys defaultConfig x)
myKeys conf@(XConfig {XMonad.modMask = modMask}) =
    [ ((modMask .|. shiftMask, xK_l), spawn "xscreensaver-command -select 2 ;  xscreensaver-command -lock")
-- Allow full screen mode
    , ((modMask, xK_f ), sendMessage ToggleLayout)
    , ((0, xF86XK_HomePage), spawn "~/bin/dump_banshee.sh")
    , ((0, xF86XK_Explorer), spawn "xscreensaver-command -select 1 ; xscreensaver-command -lock")
    , ((modMask .|. shiftMask, xK_g     ), windowPromptGoto  defaultXPConfig )
    , ((modMask .|. shiftMask, xK_b     ), windowPromptBring defaultXPConfig)
    , ((0, xF86XK_Mail), spawn "xscreensaver-command -select 2 ; xscreensaver-command -lock")
-- Return to last workspace
    , ((modMask ,  xK_b ), toggleWS )
    , ((modMask  , xK_Left  ), prevWS )
    , ((modMask  , xK_Right ), nextWS )
   -- , ((0, xF86XK_AudioRaiseVolume),   spawn "amixer set Master 2%+")
    --, ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2%-")
    , ((modMask .|. controlMask, xK_s), sshPrompt defaultXPConfig)

    , ((modMask              , xK_BackSpace), focusUrgent)
    ]
    ++
     [ ((keyMask .|. modMask, keySym), function (Lines 2) Finite direction)
    | (keySym, direction) <- zip [xK_Left .. xK_Down] $ enumFrom ToLeft
    , (keyMask, function) <- [(0, planeMove), (shiftMask, planeShift)]
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
    -- Map Super_R to prod workspaces, see .Xmodmap
    [((m .|. mod3Mask, k), windows $ f i)
        | (i, k) <- zip (prodWs(workspaces(conf))) numQwerty,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (devWs(workspaces(conf))) numQwerty,
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
          where
          devWs array = take (div (length array ) 2) array
          prodWs array = drop (div (length array ) 2) array

-- keys between ` and = on an qwerty keyboard. 13 worspaces.
numQwerty = [0x60,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x30,0x2d,0x3d]

main = do
      xmproc <- spawnPipe "xmobar"
      xmonad $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }  $ defaultConfig {
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
